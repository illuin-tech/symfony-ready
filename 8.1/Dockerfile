FROM php:8.1-alpine3.15

RUN apk update && apk add bash icu-dev postgresql-dev libzip-dev openldap-dev libpng-dev oniguruma-dev jpegoptim libjpeg libpng imagemagick-dev ghostscript git
RUN docker-php-ext-install intl mbstring pdo pdo_pgsql zip bcmath sockets ldap gd
RUN set -xe \
 && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
 && git clone https://github.com/Imagick/imagick \
 && cd imagick \
 && git checkout 3.5.1 \
 && phpize && ./configure && make && make install \
 && cd .. && rm -Rf imagick \
 && docker-php-ext-enable imagick \
 && apk add --no-cache --virtual .imagick-runtime-deps imagemagick
RUN pecl install redis && docker-php-ext-enable redis
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN apk add nodejs~=16 npm
