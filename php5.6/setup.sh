#!/bin/bash
set -e

# Add Xdebug path to php.ini
printf -v ext_dir "zend_extension=\"%s/xdebug.so\"" "$(pecl config-get ext_dir)"
echo "Installing xdebug.so as $ext_dir"
echo $ext_dir > /usr/local/etc/php/conf.d/xdebug.ini

# Install Composer
echo >&2 "Installing Composer as composer"
EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
mv composer.phar /usr/local/bin/composer
composer
# Add composer/vendor/bin to PATH
PATH=$PATH:/root/.composer/vendor/bin/

if [[ ! -z "$LARAVEL" ]]; then
    if [[ -d "/var/www/html/$LARAVEL" ]]; then
        echo >&2 "Laravel directory exists, skipping Laravel installation"
    else
        echo >&2 "Composer: install Laravel"
        composer global require "laravel/installer"
        echo >&2 "Laravel: installing in /var/www/html/$LARAVEL"
        laravel new $LARAVEL
    fi
        sed -i "s|DocumentRoot /var/www/html$|DocumentRoot /var/www/html/$LARAVEL/public|" /etc/apache2/sites-available/000-default.conf
        sed -i "s|DocumentRoot /var/www/html$|DocumentRoot /var/www/html/$LARAVEL/public|" /etc/apache2/sites-available/default-ssl.conf
elif [[ ! -z "$DOCUMENTROOT" ]]; then
    echo >&2 "Set DocumentRoot as /var/www/html/$DOCUMENTROOT"
    sed -i "s|DocumentRoot /var/www/html$|DocumentRoot /var/www/html/$DOCUMENTROOT|" /etc/apache2/sites-available/000-default.conf
    sed -i "s|DocumentRoot /var/www/html$|DocumentRoot /var/www/html/$DOCUMENTROOT|" /etc/apache2/sites-available/default-ssl.conf
    if [[ -e "/var/www/html/$DOCUMENTROOT" ]]; then
        echo '<?php phpinfo(); ?>' > /var/www/html/$DOCUMENTROOT/test.php
    fi
else
    echo >&2 "DocumentRoot unchanged"
    echo '<?php phpinfo(); ?>' > /var/www/html/test.php
fi

if [[ -f "composer.json" ]]; then
    echo >&2 "Composer: installing dependencies"
    composer install
fi

echo >&2 "Change permissions on Website files"

chown -R www-data:www-data /var/www/html
find /var/www/html -type f -exec chmod 666 {} \;
find /var/www/html -type d -exec chmod 777 {} \;

exec "$@"
