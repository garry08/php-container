FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive
ARG PHP_VERSION=7.2

RUN apt-get update \
    && apt-get upgrade --quiet --yes \
    && apt-get install software-properties-common --yes --quiet \
    && add-apt-repository ppa:ondrej/php --yes \
    && apt-get update --quiet \
    && apt-get update --quiet \
    && apt-get install --quiet --yes \
        composer \
        libicu-dev \
        libmariadbclient-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        locales \
        php${PHP_VERSION} \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-bz2 \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-imap \
        php${PHP_VERSION}-imagick \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-ldap \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-pgsql \
        php${PHP_VERSION}-redis \
        php${PHP_VERSION}-soap \
        php${PHP_VERSION}-sqlite3 \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-xmlrpc \
        php${PHP_VERSION}-xsl \
        php${PHP_VERSION}-zip \
        unzip \
    && apt-get autoremove --quiet --yes \
    && apt-get clean

# Set the locale
RUN locale-gen en_US
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime

EXPOSE 8000

# Mount your app source code directory into that folder
WORKDIR /var/www/app

# Create less privileged user
RUN groupadd --gid 1000 dev \
  && useradd --uid 1000 --gid dev --shell /bin/bash --create-home dev

# Label schema related variables and metadata
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Julien M'Poy <julien.mpoy@gmail.com>" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.vcs-url="https://github.com/groovytron/php-container" \
    org.label-schema.schema-version="1.0"

# Fix permissions issues
RUN chmod -R a+wrx /var/www/app
