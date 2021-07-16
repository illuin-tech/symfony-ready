FROM php:8.0-alpine3.13

RUN apk update && apk add bash icu-dev postgresql-dev libzip-dev openldap-dev libpng-dev oniguruma-dev
RUN docker-php-ext-install intl mbstring pdo pdo_pgsql zip bcmath sockets ldap gd
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN apk add nodejs~=14 npm
