#! /bin/bash

if [[ -z "$1" ]]; then
    printf "\nI need a domain\nUsage: $0 DOMAIN.COM\n\n"
else
    printf "\n<----- Domain Results ----->\n"
    printf "Nameservers for $1:\n"

    dig ns +short $1

    printf "\nIP address for $1:\n"
    dig +short $1

    printf "\nMX records for $1:\n"
    dig mx +short $1

    printf "\nIP address for MX records:\n"
    dig +short $(dig mx +short $1 | awk '{print $2}')

    whois $1 > ~/.whois.tmp

    printf "\nRegistrar:\n"
    grep "Registrar:" ~/.whois.tmp | sed 's/^.*Registrar://'

    printf "\nImportant Dates:\n"
    grep "Expiration" ~/.whois.tmp
    grep "Updated Date:" ~/.whois.tmp

    printf "\nAdministrative Contact:\n"
    awk '/Administrative\ Contact/ {getline;print }' ~/.whois.tmp
    grep "Admin Email:" ~/.whois.tmp

    printf "\nDomain Status:\n"
    grep "Status:" ~/.whois.tmp

    rm ~/.whois.tmp

    printf "\n<----- End of Results ----->\n\n"
fi
