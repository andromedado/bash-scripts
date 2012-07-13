#!/bin/bash
newsite=$1
template=$2
dontRestart=$3
dontGenCert=$4
if [[ $template =~ [^A-Za-z_-] || ${#template} == 0 || ! -d /var/www/vhosts/.$template || ! -f /var/www/vhosts/.$template/domain.conf || ! -d /var/www/vhosts/.$template/domain_directory ]]; then
        template="template"
fi
while true; do
    if [[ $newsite =~ ^[A-Za-z0-9\.-]+$ ]]; then
                if [[ -d /var/www/vhosts/$newsite ]]; then
                        echo "Domain Already Exists";
                else
                        break;
                fi
        else
                echo "Invalid Domain";
    fi
    read -p "Domain:" newsite
done
sudo cp -r /var/www/vhosts/.$template/domain_directory /var/www/vhosts/$newsite
sudo chown -R _www:staff /var/www/vhosts/$newsite
sudo chmod -R 775 /var/www/vhosts/$newsite
sudo sed -e s/NEWSITE/"$newsite"/g /var/www/vhosts/.$template/domain.conf > /tmp/$newsite
sudo cp /tmp/$newsite /etc/apache2/sites-available/$newsite
if [[ ! $dontGenCert ]]; then
genCert *.$newsite
fi
sudo sed -e s/NEWSITE/"$newsite"/g /var/www/vhosts/.$template/domain.conf_443 > /tmp/${newsite}_443
sudo cp /tmp/${newsite}_443 /etc/apache2/sites-available/${newsite}_443
sudo ln -s /etc/apache2/sites-available/$newsite /etc/apache2/sites-enabled/$newsite
#echo "127.0.0.1	my.$newsite" | sudo tee -a /etc/hosts
addRecord "my.$newsite" @ A 127.0.0.1
if [[ ! $dontRestart ]]; then
sudo /usr/sbin/apachectl -k graceful
fi
words="Using the template '$template'\n$newsite is now a configured virtual host on this server.\nCongratulations!"
echo -e $words
