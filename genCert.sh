#!/bin/bash
certname=$1
while [[ $certname == '' || -f /Users/shad/.ssl/$certname.crt ]]
do
read -p "Domain: " certname	
done
echo 'First, I need your '
sudo echo 'Thanks'
openssl genrsa -passout stdin -des3 -out /Users/shad/.ssl/$certname.key.tmp 2048 <<EOI
test123
EOI
openssl req -passin pass:test123 -new -key /Users/shad/.ssl/$certname.key.tmp -out /Users/shad/.ssl/$certname.csr <<EOI
US
Oregon
Portland
Home LLC
IT
$certname
us@home.com


EOI
openssl rsa -passin pass:test123 -in /Users/shad/.ssl/$certname.key.tmp -out /Users/shad/.ssl/$certname.key
rm -f /Users/shad/.ssl/$certname.key.tmp
openssl x509 -req -days 365 -in /Users/shad/.ssl/$certname.csr -signkey /Users/shad/.ssl/$certname.key -out /Users/shad/.ssl/$certname.crt
sudo chmod 644 /Users/shad/.ssl/*
open /Users/shad/.ssl/$certname.crt
echo 'Done'
