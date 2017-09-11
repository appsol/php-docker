FROM php:7.1-apache

RUN a2enmod rewrite expires

# install the PHP extensions we need
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libpng12-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    wget \
    git \
    zip \
    unzip \
    php-pclzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql opcache iconv mcrypt zip

# install Xdebug
RUN pecl install xdebug \
RUN docker-php-ext-enable xdebug

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
        echo 'error_reporting=30711'; \
        echo 'display_errors=0'; \
    } > /usr/local/etc/php/conf.d/local.ini

# Run Setup
WORKDIR /tmp

COPY setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

VOLUME /var/www/html
WORKDIR /var/www/html/

ENTRYPOINT ["setup.sh"]
CMD ["apache2-foreground"]
