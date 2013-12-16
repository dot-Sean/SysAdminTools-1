#! /usr/bin/env python

# You need to install the Twilio Python library:
# https://www.twilio.com/docs/python/install
#
# SMS settings for 'to' and 'from_' are from your Twilio account.
# 'to' is your phone number, verified within your free Twilio account.
# 'from_' is your Twilio phone number, selected at sign-up.

import logging
from os.path import isfile
from socket import gethostname
from twilio.rest import TwilioRestClient
import urllib2

log = logging.getLogger('newip.py')
log.setLevel(logging.INFO)
fh = logging.FileHandler('/var/log/newip.py.log')
fh.setLevel(logging.INFO)
frmt = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                        "%Y/%m/%d %H:%M:%S")
fh.setFormatter(frmt)
log.addHandler(fh)

ip_url = 'http://ifconfig.me/ip'
get_ip = urllib2.urlopen(ip_url)
my_ip = get_ip.read().strip()

account_sid = '<Twilio Account SID>'
auth_token = '<Twilio Authentication Token>'
client = TwilioRestClient(account_sid, auth_token)

my_host = gethostname()
ip_file = '~/.twilio/ip'
if isfile(ip_file):
    with open(ip_file, 'r') as old_ip:
        cur_ip = old_ip.read()
        if cur_ip == my_ip:
            log.info("IP address is the same -- %s", my_ip)
        else:
            log.info("IP address has changed -- %s", my_ip)
            with open(ip_file, 'w') as new_ip:
                new_ip.write(my_ip)
            sms = client.messages.create(to='+1<your_phone#>',
                                        from_='+1<twilio_phone#>',
                                        body="New IP: "+my_host+": "+my_ip)
else:
    with open(ip_file, 'w') as save_ip:
        save_ip.write(my_ip)
    log.info("IP address established -- %s", my_ip)
    sms = client.messages.create(to='+1<your_phone#>',
                                from_='+1<twilio_phone#>',
                                body="Set IP: "+my_host+": "+my_ip)
