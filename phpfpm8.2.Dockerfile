FROM php:8.2-fpm-bookworm

ENV ACCEPT_EULA=Y

ADD ./sources.list /etc/apt/sources.list


RUN apt-get update \
    && apt-get install -y --no-install-recommends zsh git \
    && curl -fsSL https://starship.rs/install.sh | sh -s -- -y

WORKDIR /var/www

RUN chsh -s /bin/bash www-data && usermod -c "umask=002" www-data

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
        git-all \
        openssh-client \
        curl \
        gnupg \
        libz-dev \
        libzip-dev \
        libpq-dev \
        libssl-dev \
        libmcrypt-dev \
        libxml2-dev \
        apt-transport-https \
        ffmpeg \
        jpegoptim optipng pngquant

### Common ext
RUN docker-php-ext-install -j$(nproc) \
        mysqli \
        zip \
        pdo_mysql \
        bcmath \
        exif \
        soap

### iconv and gd extensions
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

### redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

### xmlrpc
RUN pecl install -o -f xmlrpc \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable xmlrpc

## imagick
RUN apt-get -y install libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick

## exif
RUN docker-php-ext-install exif \
    && docker-php-ext-configure exif --enable-exif

## composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
