#!/bin/sh

# Change the values over here.
VALID_DAYS = 365
COUNTRY = "PH"
STATE = "NCR"
CITY = "Quezon City"
ORG = "ACME Dev"
ORG_UNIT = "IT Department"

openssl req \
        -x509 \
        -nodes \
        -days $VALID_DAYS \
        -newkey rsa:2048 \
        -keyout server.key \
        -out server.crt \
        -subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORG/OU=$ORG_UNIT/CN=docker.localhost"