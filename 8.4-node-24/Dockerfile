FROM php:8.4-cli-trixie

ENV XDEBUG_MODE=off

RUN apt-get update -q -y \
    && apt-get upgrade -q -y \
    && curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash - \
    && apt-get install -q -y postgresql-client libcurl4-gnutls-dev zlib1g-dev libicu-dev g++ libxml2-dev libpq-dev \
      libonig-dev libzip-dev libldb-dev libldap2-dev libfreetype-dev libjpeg62-turbo-dev libpng-dev libxrender-dev \
      librabbitmq-dev git git-lfs unzip procps locales build-essential xmlstarlet bc wget \
      libmagickwand-dev libmagickcore-dev imagemagick ghostscript fcgiwrap qpdf symfony-cli \
    && apt-get autoremove && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-source extract \
    && pecl install redis \
    && pecl install amqp \
    && pecl install xdebug \
    && pecl install imagick \
    && docker-php-ext-enable redis amqp imagick xdebug \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install intl mbstring pdo pdo_pgsql pdo_mysql zip bcmath sockets ldap opcache pcntl soap \
    && docker-php-source delete \
    && echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini \
    && sed -i 's#</policymap>#  <policy domain="coder" rights="read|write" pattern="{PS,PDF,XPS}" />\n</policymap>#' /etc/ImageMagick-7/policy.xml

# Install libssl1.1 (deprecated) depending on arch mandatory for wkhtlmtopdf
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        PACKAGE="libssl1.1_1.1.1w-0+deb11u1_amd64.deb"; \
    elif [ "$ARCH" = "arm64" ]; then \
        PACKAGE="libssl1.1_1.1.1w-0+deb11u1_arm64.deb"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    wget http://ftp.us.debian.org/debian/pool/main/o/openssl/$PACKAGE && \
    dpkg -i $PACKAGE && \
    rm $PACKAGE

RUN mkdir /tools && cd /tools && wget https://phar.phpunit.de/phpcov-11.0.1.phar && cd - && php /tools/phpcov-11.0.1.phar --version

# Install composer 2
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install node24
COPY --from=node:24-trixie /usr/local/bin /usr/local/bin
COPY --from=node:24-trixie /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN node --version && npm --version # smoke test
