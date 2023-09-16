FROM php:5.6-fpm-stretch

ENV ACCEPT_EULA=Y

# ADD ./sources.list /etc/apt/sources.list
RUN <<EOF
cat <<EOT > /etc/apt/sources.list 
deb http://archive.debian.org/debian/ stretch main contrib non-free 
deb http://archive.debian.org/debian/ stretch-proposed-updates main contrib non-free 
deb http://archive.debian.org/debian-security stretch/updates main contrib non-free 
EOT
EOF

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
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
        jpegoptim optipng pngquant \
        && apt-get install -y --no-install-recommends zsh \
        && curl -fsSL https://starship.rs/install.sh | sh -s -- -y

### Common ext
RUN docker-php-ext-install -j$(nproc) \
        mysqli \
        zip \
        pdo_mysql \
        bcmath \
        exif \
        pcntl \
        mcrypt \
        soap


WORKDIR /var/www


### The uopz extension is focused on providing utilities to aid with unit testing PHP code.
### Required by packages like ClockMock. https://github.com/slope-it/clock-mock
# RUN pecl install -o -f uopz-6.1.2 \
#     &&  docker-php-ext-enable uopz

### Microsoft Drivers for PHP for SQL Server
### https://docs.microsoft.com/en-us/sql/connect/php/microsoft-php-driver-for-sql-server?view=sql-server-2017
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# RUN curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list

# RUN apt-get update
# RUN apt-get install -y --no-install-recommends  msodbcsql17 unixodbc-dev

# RUN pecl install sqlsrv pdo_sqlsrv \
#     && docker-php-ext-enable sqlsrv pdo_sqlsrv
