#BASE
FROM php:7.3-fpm
#WORKDIR /build
RUN apt-get update && \
    apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libicu-dev \
    libzip-dev \
    libldb-dev \
    libldap2-dev \
    procps \
    vim \
    nginx \
    supervisor \
    && docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
    opcache \
    intl \
    pcntl \
    ldap \
    zip \
    mysqli \
    && docker-php-ext-enable \
    ldap \
    && apt purge -y $PHPIZE_DEPS \
    && apt autoremove -y --purge \
    && apt clean all

## RUNTIME
#FROM php-base as php-runtime
#WORKDIR /app
#RUN chown -R www-data:www-data /app
#ENV CHROOT_WWW_DIR=/app

# PHP-FPM
COPY .docker/conf/php.ini $PHP_INI_DIR/php.ini
RUN rm /usr/local/etc/php-fpm.d/*
COPY .docker/conf/fpm.conf /usr/local/etc/php-fpm.d/www.conf

# NGINX
RUN rm /etc/nginx/nginx.conf && chown -R www-data:www-data /var/www/html /run /var/lib/nginx /var/log/nginx
COPY .docker/conf/nginx.conf /etc/nginx/nginx.conf

#USER www-data
#
#COPY --chown=www-data:www-data . .
#
#EXPOSE 8080
#ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
