FROM php:7.0-apache-stretch

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y zlib1g-dev imagemagick ghostscript libmagickwand-dev && apt clean -y
RUN docker-php-ext-install mysqli mbstring pdo pdo_mysql bcmath zip
RUN pecl install xdebug-2.7.2 && docker-php-ext-enable xdebug
RUN pecl install imagick && docker-php-ext-enable imagick
RUN a2enmod headers

EXPOSE 80 5000 8000
