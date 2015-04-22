FROM php:5.4-apache
MAINTAINER zaporylie <jakub@piaseccy.pl>

WORKDIR /var/www/html

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    mysql-server-5.5 \
    mysql-client \
    unzip

RUN apt-get update && apt-get install -y libfreetype6 libjpeg62-turbo libmcrypt4 libpng12-0 sendmail --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN buildDeps=" \
        libfreetype6-dev \
        libjpeg-dev \
        libldap2-dev \
        libmcrypt-dev \
        libpng12-dev \
        zlib1g-dev \
    "; \
    set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu --with-png-dir=/usr/lib/x86_64-linux-gnu --with-freetype-dir=/usr/lib/x86_64-linux-gnu \
    && docker-php-ext-install gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install ldap \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip \
    && apt-get purge -y --auto-remove $buildDeps \
    && cd /usr/src/php \
    && make clean

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && HOME=/ /usr/local/bin/composer global require drush/drush:dev-master

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get -yq install git

COPY ./start.sh /start.sh

RUN chmod u+x /start.sh
  

ENV GIT_BRANCH=8.0.x \
  GIT_PATCH="" \
  TESTS="--verbose --all"

CMD ["/bin/bash", "/start.sh"]
