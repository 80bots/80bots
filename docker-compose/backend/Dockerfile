FROM php:7.4-fpm

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV HOME /root

# Install platform dependencies
RUN apt-get update
RUN apt-get install -y libmcrypt-dev
RUN apt-get install -y default-mysql-client
RUN apt-get install -y libpspell-dev
RUN apt-get install -y freetds-dev
RUN apt-get install -y unixodbc unixodbc-dev
RUN apt-get install -y libxslt-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libldap2-dev
RUN apt-get install -y libmagickwand-dev --no-install-recommends
RUN apt-get install -y build-essential
RUN apt-get install -y libpq-dev
RUN apt-get install -y libbz2-dev
RUN apt-get install -y libonig-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y libzip-dev
RUN apt-get install -y libjpeg62-turbo-dev
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libgmp-dev
RUN apt-get install -y libtidy-dev
RUN apt-get install -y locales
RUN apt-get install -y zip
RUN apt-get install -y jpegoptim optipng pngquant gifsicle
RUN apt-get install -y vim
RUN apt-get install -y unzip
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install -y apt-utils
RUN apt-get install -y systemd
RUN apt-get install -y supervisor
RUN apt-get install -y cron
RUN apt-get install -y iputils-ping
# Auxilary utils / Network management
RUN apt-get install -y nano
RUN apt-get install -y traceroute
RUN apt-get install -y dnsutils

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install calendar \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install dba \
    && docker-php-ext-install gettext \
    && docker-php-ext-install gmp \
    && docker-php-ext-install zip \
    && docker-php-ext-install exif \
    && docker-php-ext-install intl \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install opcache \
    && docker-php-ext-install pspell \
    && docker-php-ext-install shmop \
    && docker-php-ext-install soap \
    && docker-php-ext-install sockets \
    && docker-php-ext-install sysvmsg \
    && docker-php-ext-install sysvsem \
    && docker-php-ext-install sysvshm \
    && docker-php-ext-install tidy

#PHP XDebug ext
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host = host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

#PHP Redis ext
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

#PHP gd ext
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

#PHP imagick ext
RUN rm -rf /var/lib/apt/lists/* \
    && printf "\n" | pecl install imagick \
    && docker-php-ext-enable imagick

#PHP ldap ext
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install ldap

#PHP mailparse
RUN pecl install mailparse \
    && docker-php-ext-enable mailparse

# install mongodb ext
RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./.ssh $HOME/.ssh

RUN chmod 400 $HOME/.ssh/id_rsa
RUN touch $HOME/.ssh/known_hosts && ssh-keyscan github.com >> $HOME/.ssh/known_hosts

# Load cron script
COPY ./cron/laravel-scheduler /etc/cron.d/laravel-scheduler
RUN chmod 0644 /etc/cron.d/laravel-scheduler

# Load start script
COPY ./bin/start.sh /var/www/start.sh
RUN chmod 700 /var/www/*.sh

# Set API
WORKDIR /var/www