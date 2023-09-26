FROM devilbox/php-fpm:5.3-prod

ENV ACCEPT_EULA=Y

## composer
COPY --from=composer:2.2 /usr/bin/composer /usr/local/bin/composer