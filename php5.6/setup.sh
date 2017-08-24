#!/bin/bash
set -e

# Add Xdebug path to php.ini
printf -v ext_dir "zend_extension=\"%s/xdebug.so\"" "$(pecl config-get ext_dir)"
echo "Installing xdebug.so as $ext_dir"
echo $ext_dir > /usr/local/etc/php/conf.d/xdebug.ini

# Install Composer
echo >&2 "Installing Composer as composer"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
composer

if [[ ! -z "$LARAVEL" ]]; then
    echo >&2 "Composer: install Laravel"
    composer global require "laravel/installer"
    echo >&2 "Laravel: creating new $LARAVEL"
    laravel new $LARAVEL
    sed -i "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/$LARAVEL\/public/" /etc/apache2/sites-available/000-default.conf
    sed -i "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/$LARAVEL\/public/" /etc/apache2/sites-available/default-ssl.conf
elif [[ ! -z "$DOCUMENTROOT" ]]; then
    echo >&2 "Set DocumentRoot as /var/www/html/$DOCUMENTROOT"
    sed -i "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/$DOCUMENTROOT/" /etc/apache2/sites-available/000-default.conf
    sed -i "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/$DOCUMENTROOT/" /etc/apache2/sites-available/default-ssl.conf
else
    echo >&2 "DocumentRoot unchanged"
fi

if [[ -f "composer.json" ]]; then
    echo >&2 "Composer: installing dependencies"
    composer install
fi

echo '<?php phpinfo(); ?>' > /var/www/html/test.php

echo >&2 "Change permissions on Website files"

chown -R www-data:www-data /var/www/html
find /var/www/html -type f -exec chmod 666 {} \;
find /var/www/html -type d -exec chmod 777 {} \;

exec "$@"
