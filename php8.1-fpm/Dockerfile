FROM ubuntu:22.04

LABEL maintainer="Stuart Laverick"

# Set working directory
WORKDIR /var/www/html

# Set needed environment variables before installing PHP.
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

# Set the time zone and locale
RUN apt-get update \
    && apt-get install -y locales gnupg tzdata \
    && echo "UTC" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && locale-gen en_GB.UTF-8

# install the Packages needed
RUN apt-get update \
    && apt-get install -y \
    locales \
    nginx \
    curl \
    wget \
    zip \
    unzip \
    git \
    software-properties-common \
    supervisor

# Install PHP 8.1
RUN apt-add-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php8.1-fpm php8.1-cli php8.1-gd php8.1-mysql php8.1-redis \
       php8.1-imap php8.1-mbstring php8.1-xml php8.1-curl php8.1-zip \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php

# Cleanup.
RUN apt-get remove -y --purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add configuration files
ADD conf/opcache-recommended.ini /usr/local/etc/php/conf.d/opcache.ini
ADD conf/php-fpm.conf /etc/php/8.1/fpm/php-fpm.conf
ADD conf/local.ini /etc/php/8.1/fpm/conf.d/100-local.ini
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add the bootstrap script.
ADD bin/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose port 9000
EXPOSE 9000

# Set default command to the bootstrap script.
CMD ["start.sh"]
