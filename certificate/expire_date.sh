#!/bin/bash

EMAIL="email@email.com"
DAYS=14;

for i in google.coom \
        portal.azure.com \
        amazon.com;
do
  DOMAIN=$i
  echo "Checking if $DOMAIN expires in less than $DAYS days";
  expirationdate=$(date -d "$(: | openssl s_client -connect $DOMAIN:443 -servername $DOMAIN 2>/dev/null \
                                | openssl x509 -text \
                                | grep 'Not After' \
                                |awk '{print $4,$5,$7}')" '+%s');
  nDays=$(($(date +%s) + (86400*$DAYS)));
  if [ $nDays -gt $expirationdate ];
  then
    echo "Certificate for $DOMAIN expires in less than $DAYS days, on $(date -d @$expirationdate '+%Y-%m-%d'). Please renew it." \
    | mail -s "[WARNING] - Certificate expiration for $DOMAIN" $EMAIL ;
  else
    echo "OK - Certificate expires on `date -d @$expirationdate` ";
  fi;
done
