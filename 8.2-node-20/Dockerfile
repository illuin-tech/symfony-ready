FROM php:8.2-alpine3.18

RUN apk update \
    && apk upgrade \
    && apk add bash linux-headers icu-dev postgresql-dev libzip-dev openldap-dev libpng-dev oniguruma-dev jpegoptim \
    libjpeg libpng imagemagick-dev ghostscript git libxslt-dev rabbitmq-c-dev icu-data-full openssl1.1-compat \
    xmlstarlet \
    && apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main nodejs~=20 \
    && apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community npm~=10

RUN docker-php-ext-install intl mbstring pdo pdo_pgsql zip bcmath sockets ldap gd xsl
RUN set -xe && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS
RUN pecl install imagick-3.7.0 \
 && docker-php-ext-enable imagick \
 && apk add --no-cache --virtual .imagick-runtime-deps imagemagick
RUN pecl install redis xdebug && docker-php-ext-enable redis xdebug
RUN echo -e '\n' | pecl install -o -f amqp && docker-php-ext-enable amqp
ENV XDEBUG_MODE=off

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
