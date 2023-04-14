FROM php:8.1-alpine3.15

RUN apk update && apk add bash icu-dev postgresql-dev libzip-dev openldap-dev libpng-dev oniguruma-dev jpegoptim libjpeg libpng imagemagick-dev ghostscript git libxslt-dev
RUN docker-php-ext-install intl mbstring pdo pdo_pgsql zip bcmath sockets ldap gd xsl
RUN set -xe \
 && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS
RUN pecl install imagick-3.7.0 \
 && docker-php-ext-enable imagick \
 && apk add --no-cache --virtual .imagick-runtime-deps imagemagick
RUN pecl install redis && docker-php-ext-enable redis
RUN apk add linux-headers && pecl install xdebug && docker-php-ext-enable xdebug
ENV XDEBUG_MODE=off
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN apk add nodejs~=16 npm
