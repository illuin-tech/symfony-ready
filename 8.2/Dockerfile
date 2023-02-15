FROM php:8.2-alpine3.17

RUN apk update && apk add bash linux-headers icu-dev postgresql-dev libzip-dev openldap-dev libpng-dev oniguruma-dev jpegoptim libjpeg libpng imagemagick-dev ghostscript git
RUN docker-php-ext-install intl mbstring pdo pdo_pgsql zip bcmath sockets ldap gd
RUN set -xe \
 && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS
RUN pecl install imagick-3.7.0 \
 && docker-php-ext-enable imagick \
 && apk add --no-cache --virtual .imagick-runtime-deps imagemagick
RUN pecl install redis && docker-php-ext-enable redis
RUN apk add linux-headers && pecl install xdebug && docker-php-ext-enable xdebug
ENV XDEBUG_MODE=off
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN apk add nodejs~=18 npm
