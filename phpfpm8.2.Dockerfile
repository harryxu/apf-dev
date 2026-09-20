FROM php:8.2-fpm-bookworm

ENV ACCEPT_EULA=Y
ENV DEBIAN_FRONTEND=noninteractive

COPY ./sources.list /etc/apt/sources.list

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        zsh \
        git \
        ca-certificates \
        curl \
        gnupg \
        git-all \
        openssh-client \
        libz-dev \
        libzip-dev \
        libpq-dev \
        libssl-dev \
        libmcrypt-dev \
        libxml2-dev \
        libicu-dev \
        libonig-dev \
        apt-transport-https \
        ffmpeg \
        jpegoptim \
        optipng \
        pngquant \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libmagickwand-dev \
        && curl -fsSL https://starship.rs/install.sh | sh -s -- -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

RUN chsh -s /bin/bash www-data && usermod -c "umask=002" www-data

### Common PHP extensions
RUN set -eux; \
    docker-php-ext-install -j$(nproc) \
        mysqli \
        zip \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        bcmath \
        exif \
        soap \
        intl \
        mbstring; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j$(nproc) gd

### redis, xmlrpc, imagick
RUN set -eux; \
    pecl install -o -f redis xmlrpc imagick; \
    docker-php-ext-enable redis xmlrpc imagick; \
    rm -rf /tmp/pear

### composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

CMD ["php-fpm"]
