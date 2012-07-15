#!/bin/bash
existing=$1
avoidRestart=$2
while true; do
    if [[ $existing =~ ^[A-Za-z0-9\.]+$ ]]; then
                if [[ ! -d /var/www/vhosts/$existing ]]; then
                        if [[ -d /var/www/vhosts/it.$existing && -d /var/www/vhosts/dev.$existing ]]; then
                                /usr/local/bin/scripts/rmsite.sh "it.${existing}" true
                                /usr/local/bin/scripts/rmsite.sh "dev.${existing}"
                                exit
                        fi
                        echo "Domain Not Found"
                else
                        break;
                fi
        else
                echo "Invalid Domain";
    fi
    read -p "Domain:" existing
done
echo "Removing $existing's files..."
sudo rm -f /etc/apache2/sites-available/$existing
sudo rm -f /etc/apache2/sites-enabled/$existing
sudo rm -rf /var/www/vhosts/$existing
if [[ -f /etc/apache2/sites-enabled/${existing}_443 ]]
then
sudo rm -f /etc/apache2/sites-enabled/${existing}_443
fi
if [[ -f /etc/apache2/sites-available/${existing}_443 ]]
then
sudo rm -f /etc/apache2/sites-available/${existing}_443
fi
rmRecord "my.$existing" @ A 127.0.0.1
if [[ ! $avoidRestart ]]; then
sudo /usr/sbin/apachectl -k graceful
fi
echo "$existing has been purged"
