SysAdmin Tools
==============

## DNS.sh

USAGE: dns.sh DOMAIN.TLD

(dig)  
Nameservers  
A record for domain  
MX records  
A record for MX records  

(whois) ** see notes below  
Registrar  
Important dates (expire and updated)  
Administrative contact  
Domain status  

** WhoIs information is not standardized, so the output  
   may not be what you are expecting; empty, unavailable, etc.

***

## IPLIST.pl

USAGE: iplist.pl  

Prompts for an IP address entry, and searches your iptables chain  
for a matching entry. If a match is found, delete option is then  
made available, based on listing ID.  

***

## NEWIP.py

USAGE: newip.py  

Using the Twilio service, this will SMS your new IP address. Helpful when your  
ISP changes your IP without notice. Setting this script on a cron can be a good  
use, as verification of IP change can trigger the SMS.  
