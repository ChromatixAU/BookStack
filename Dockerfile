FROM php:7.1-apache

ENV BOOKSTACK=BookStack \
    BOOKSTACK_VERSION=0.17.4 \
    BOOKSTACK_HOME="/var/www/bookstack" \
    ARCHIVE_URL="https://github.com/ChromatixAU/BookStack/archive"

RUN apt-get update && apt-get install -y \
    git zlib1g-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    wget \
    libldap2-dev \
    libtidy-dev \
  && docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    zip \
    tidy \
  && docker-php-ext-configure ldap \
    --with-libdir=lib/x86_64-linux-gnu/ \
  && docker-php-ext-install ldap \
  && docker-php-ext-configure gd \
    --with-freetype-dir=usr/include/ \
    --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && cd /var/www && curl -sS https://getcomposer.org/installer | php \
  && mv /var/www/composer.phar /usr/local/bin/composer \
  && wget ${ARCHIVE_URL}/v${BOOKSTACK_VERSION}.tar.gz -O ${BOOKSTACK}.tar.gz \
  && tar -xf ${BOOKSTACK}.tar.gz \
  && mv BookStack-${BOOKSTACK_VERSION} ${BOOKSTACK_HOME} \
  && rm ${BOOKSTACK}.tar.gz  \
  && cd $BOOKSTACK_HOME \
  && composer install \
  && chown -R www-data:www-data $BOOKSTACK_HOME \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /etc/apache2/sites-enabled/000-*.conf

COPY php.ini /usr/local/etc/php/php.ini
COPY bookstack.conf /etc/apache2/sites-enabled/bookstack.conf
RUN a2enmod rewrite

COPY docker-entrypoint.sh /

WORKDIR $BOOKSTACK_HOME

EXPOSE 80

VOLUME ["$BOOKSTACK_HOME/public/uploads","$BOOKSTACK_HOME/public/storage"]

CMD ["/docker-entrypoint.sh"]

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.license="MIT" \
      org.label-schema.name="BookStack" \
      org.label-schema.vendor="ChromatixAU" \
      org.label-schema.url="https://github.com/ChromatixAU/BookStack/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/ChromatixAU/BookStack.git" \
      org.label-schema.vcs-type="Git"