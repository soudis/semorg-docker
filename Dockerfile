FROM mediawiki:stable

RUN apt update && apt install -y zip unzip zlib1g-dev

RUN docker-php-ext-install zip

WORKDIR /var/www/html

RUN curl --silent --show-error https://getcomposer.org/installer | php

ADD LocalSettings.php.additional ./
ADD docker-entrypoint.sh ./

RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ./docker-entrypoint.sh
EXPOSE 80
CMD ["apache2-foreground"]