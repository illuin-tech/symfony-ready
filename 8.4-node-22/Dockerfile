FROM php:8.4-cli-bookworm

RUN apt-get update -q -y \
    && apt-get upgrade -q -y \
    && curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash - \
    && apt-get install -q -y postgresql-client libcurl4-gnutls-dev zlib1g-dev libicu-dev g++ libxml2-dev libpq-dev \
      libonig-dev libzip-dev libldb-dev libldap2-dev libfreetype-dev libjpeg62-turbo-dev libpng-dev libxrender-dev \
      librabbitmq-dev software-properties-common git git-lfs unzip procps locales build-essential xmlstarlet bc wget \
      libmagickwand-dev libmagickcore-dev imagemagick ghostscript fcgiwrap symfony-cli \
    && apt-get autoremove && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-source extract \
    && pecl install redis \
    && pecl install amqp \
    && pecl install xdebug \
    && docker-php-ext-enable redis amqp xdebug \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install intl mbstring pdo pdo_pgsql pdo_mysql zip bcmath sockets ldap opcache pcntl soap \
    && docker-php-source delete \
    && echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

# TODO: Install directly imagick v3.8.0 with pecl once it is released (https://github.com/Imagick/imagick/issues/697)
RUN pecl download imagick \
    && tar -xzf imagick-*.tgz \
    && cd imagick-* \
    && phpize \
    && ./configure CPPFLAGS='-Dphp_strtolower=zend_str_tolower' \
    && make -j$(nproc) \
    && make install \
    && cd .. \
    && rm -rf imagick-* \
    && docker-php-ext-enable imagick

RUN mkdir /tools && cd /tools && wget https://phar.phpunit.de/phpcov.phar && cd - && php /tools/phpcov.phar --version

ENV XDEBUG_MODE=off

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install node and npm (compile from source as done to build the node:22-alpine3.20 image)
RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

ENV NODE_VERSION=22.14.0

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armv7l';; \
    i386) ARCH='x86';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  # use pre-existing gpg directory, see https://github.com/nodejs/docker-node/pull/1895#issuecomment-1550389150
  && export GNUPGHOME="$(mktemp -d)" \
  # gpg keys listed at https://github.com/nodejs/node#release-keys
  && set -ex \
  && for key in \
    C0D6248439F1D5604AAFFB4021D900FFDB233756 \
    DD792F5973C6DE52C432CBDAC77ABFA00DDBF2B7 \
    CC68F5A3106FF448322E48ED27F5E38D5B0A215F \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    890C08DB8579162FEE0DF9DB8BEAB4DFCF555EF4 \
    C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
    108F52B48DB57BB0CC439B2997B01419BD92F80A \
    A363A499291CBBC940DD62E41F10027AF002F8B0 \
  ; do \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && gpgconf --kill all \
  && rm -rf "$GNUPGHOME" \
  && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  # smoke tests
  && node --version \
  && npm --version
