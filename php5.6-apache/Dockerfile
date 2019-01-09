FROM php:5.6-apache

LABEL maintainer="Stuart Laverick"

# Set working directory
WORKDIR /var/www/html

# Set the time zone
RUN apt-get update \
    && apt-get install -y gnupg tzdata \
    && echo "UTC" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

# install the PHP extensions we need
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    curl \
    git \
    jpegoptim optipng pngquant gifsicle \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    locales \
    nano \
    php-pclzip \
    php5-mysql \
    ssl-cert \
    supervisor \
    unzip \
    zip \
    && docker-php-ext-configure gd --with-gd --with-png-dir=/usr/include --with-jpeg-dir=/usr/include --with-freetype-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) gd mbstring mysqli pdo_mysql opcache iconv mcrypt zip \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable Apache mods and SSL site
RUN a2enmod rewrite expires ssl

# Change the document root if required
RUN if [ ! -z "$DOCUMENTROOT" ]; then \
        sed -i "s|DocumentRoot /var/www/html$|DocumentRoot /var/www/html/$DOCUMENTROOT|" /etc/apache2/sites-available/000-default.conf; \
    fi;

# Configure Opcache
ADD conf/opcache-recommended.ini /usr/local/etc/php/conf.d/opcache.ini

# Configure PHP
ADD conf/local.ini /usr/local/etc/php/conf.d/local.ini

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Change current user to www
USER www

# Install Composer dependancies
RUN if [ -f "composer.json" ]; then \
        composer install; \
    fi;

CMD ["apache2-foreground"]
