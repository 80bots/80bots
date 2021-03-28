FROM php:7.4-fpm

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install platform dependencies
RUN apt-get update && apt-get install -y \
    libmcrypt-dev \
    default-mysql-client \
    libpspell-dev \
    freetds-dev \
    unixodbc unixodbc-dev \
    libxslt-dev \
    libxml2-dev \
    libldap2-dev \
    libmagickwand-dev --no-install-recommends \
    build-essential \
    libpq-dev \
    libbz2-dev \
    libonig-dev \
    libpng-dev \
    libzip-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libgmp-dev \
    libtidy-dev \
    locales \
    zip \
    jpegoptim \
    optipng \
    pngquant \
    gifsicle \
    unzip \
    git \
    curl \
    apt-utils \
    systemd \
    supervisor \
    cron \
    iputils-ping \
    nano \
    traceroute \
    dnsutils \
    htop

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install \
    pdo_mysql \
    bz2 \
    calendar \
    bcmath \
    dba \
    gettext \
    gmp \
    zip \
    exif \
    intl \
    pcntl \
    mysqli \
    opcache \
    pspell \
    shmop \
    soap \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    tidy

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

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Load cron script
COPY ./cron/laravel-scheduler /etc/cron.d/laravel-scheduler
RUN chmod 0644 /etc/cron.d/laravel-scheduler

# Load start script
RUN mkdir /var/src
COPY ./bin/start.sh /var/src/start.sh
RUN chmod 700 /var/src/start.sh

# Verbose logging
RUN echo "php_admin_value[error_reporting] = E_ALL & ~E_NOTICE & ~E_WARNING & ~E_STRICT & ~E_DEPRECATED">>/usr/local/etc/php-fpm.d/www.conf

# Set API
WORKDIR /var/www

EXPOSE 9000

CMD /var/src/start.sh