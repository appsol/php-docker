FROM php:7.2-fpm

LABEL maintainer="Stuart Laverick"

# Set working directory
WORKDIR /var/www/html

# Set the time zone
RUN apt-get update \
    && apt-get install -y gnupg tzdata \
    && echo "UTC" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

# install the Packages and PHP extensions we need
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    curl \
    git \
    jpegoptim optipng pngquant gifsicle \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    locales \
    mysql-client \
    nano \
    supervisor \
    unzip \
    zip \
    && docker-php-ext-configure gd --with-gd --with-png-dir=/usr/include --with-jpeg-dir=/usr/include --with-freetype-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) gd mbstring pdo_mysql opcache zip \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install and Configure Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "zend_extension=\"$(pecl config-get ext_dir)/xdebug.so\"" > /usr/local/etc/php/conf.d/xdebug.ini

# Configure Opcache
ADD conf/opcache-recommended.ini /usr/local/etc/php/conf.d/opcache.ini

# Configure PHP
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
ADD conf/local.ini /usr/local/etc/php/conf.d/local.ini

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]