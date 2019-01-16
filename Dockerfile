FROM mediawiki:lts

RUN apt update && apt install -y zip unzip zlib1g-dev

RUN docker-php-ext-install zip

WORKDIR /var/www/html

RUN git clone https://github.com/thaider/Tweeki /var/www/html/skins/Tweeki \
    && git clone https://gerrit.wikimedia.org/r/p/mediawiki/extensions/PageForms.git /var/www/html/extensions/PageForms \
    && git clone https://github.com/oteloegen/SemanticOrganization.git /var/www/html/extensions/SemanticOrganization

RUN curl --silent --show-error https://getcomposer.org/installer | php

RUN php composer.phar require mediawiki/semantic-media-wiki "~2.5" --update-no-dev \
    && php composer.phar require mediawiki/semantic-result-formats "~2.5" --update-no-dev

ADD LocalSettings.php.additional ./
ADD docker-entrypoint.sh ./

RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ./docker-entrypoint.sh
EXPOSE 80
CMD ["apache2-foreground"]

