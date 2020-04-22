FROM php:7.3-alpine

RUN apk update && apk add icu-dev postgresql-dev libzip-dev openldap-dev libpng-dev
RUN docker-php-ext-install intl json mbstring pdo pdo_pgsql zip bcmath sockets ldap gd
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer
RUN apk add npm~=12

