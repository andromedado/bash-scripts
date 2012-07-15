#!/bin/bash
db=$1
usr=$2
pswd=$3
mysql --user=root --password=root <<EOT
CREATE DATABASE ${1};
CREATE USER '${2}'@'localhost' IDENTIFIED BY '${3}';
GRANT ALL ON ${1}.* TO '${2}'@'localhost';
EOT
