FROM php:7.4-fpm

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
    apt-utils \
    build-essential \
    curl \
    git \
    jpegoptim optipng pngquant gifsicle \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    libwebp-dev \
    libxml2-dev \
    libxslt1-dev \
    locales \
    mariadb-client \
    postgresql-client \
    nano \
    ssl-cert \
    supervisor \
    unzip \
    libzip-dev \
    && docker-php-ext-configure gd --enable-gd --with-jpeg --with-webp --with-freetype \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install -j$(nproc) bcmath intl gd mysqli opcache pdo_mysql pdo_pgsql soap xsl zip \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install and Configure Xdebug
RUN pecl install xdebug-2.8.1 \
    && docker-php-ext-enable xdebug

# Install and configure PHP Redis
RUN pecl install redis-5.1.1 \
    && docker-php-ext-enable redis

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