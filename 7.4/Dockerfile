FROM php:7.4-alpine3.12

RUN apk update && apk add icu-dev postgresql-dev libzip-dev openldap-dev libpng-dev oniguruma-dev libxslt-dev
RUN docker-php-ext-install intl json mbstring pdo pdo_pgsql zip bcmath sockets ldap gd xsl
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer --1
RUN apk add npm~=12
