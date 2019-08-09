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
    apt-utils \
    build-essential \
    curl \
    git \
    jpegoptim optipng pngquant gifsicle \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev \
    libxslt1-dev \
    locales \
    nano \
    mariadb-client \
    ssl-cert \
    supervisor \
    unzip \
    zip \
    && docker-php-ext-configure gd --with-gd --with-png-dir=/usr/include --with-jpeg-dir=/usr/include --with-freetype-dir=/usr/include \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) gd iconv mbstring mcrypt mysqli opcache pdo_mysql soap xsl zip \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable Apache mods and SSL site
RUN a2enmod rewrite expires ssl

# Configure Opcache
ADD conf/opcache-recommended.ini /usr/local/etc/php/conf.d/opcache.ini

# Configure PHP
ADD conf/local.ini /usr/local/etc/php/conf.d/local.ini

ENV DOCUMENTROOT /var/www/html

RUN sed -ri -e 's!/var/www/html!${DOCUMENTROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${DOCUMENTROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Add user for php application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www
RUN chown -R www:www-data /var/www/html;

CMD ["apache2-foreground"]
