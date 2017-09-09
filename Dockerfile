FROM php:7.0-alpine

MAINTAINER christian@zimnick.de
COPY typo3.ini /usr/local/etc/php/conf.d/typo3.ini

RUN set -xe \
    && apk add --no-cache --update -f git unzip wget libwebp-dev libjpeg-turbo-dev \
                        libpng-dev mysql-client freetype freetype-dev \
                        bash curl apache-ant libxml2-dev alpine-sdk autoconf \
                        libxpm-dev libxml2-dev curl-dev \
					    libmcrypt-dev \

    && docker-php-ext-configure gd --with-jpeg-dir=/usr/lib --with-freetype-dir=/usr/include --with-webp-dir=/usr/include \
    && docker-php-ext-install pdo pdo_mysql mbstring gd zip dom mcrypt mysqli \
    && pecl install xdebug \
    && echo "zend_extension=xdebug.so" > /usr/local/etc/php/conf.d/0000_xdebug.ini \
    && mkdir /shopware \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && mkdir /typo3/ \
    && apk del --update --purge alpine-sdk autoconf \
    && composer clearcache \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/* \
    && rm -rf /usr/share/php7

WORKDIR /typo3

CMD ["/bin/bash"]
