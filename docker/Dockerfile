# Dev and test image: the pinned WordPress + PHP 8.3 image plus pcov (coverage) and a DB client.
FROM wordpress:7.1.3-php8.3-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends $PHPIZE_DEPS mariadb-client \
    && pecl install pcov-1.0.12 \
    && docker-php-ext-enable pcov \
    && apt-get purge -y --auto-remove $PHPIZE_DEPS \
    && rm -rf /var/lib/apt/lists/* /tmp/pear

# pcov is on only when a coverage run asks for it.
RUN printf 'pcov.enabled=0\npcov.directory=/workspace/wp-content\n' > /usr/local/etc/php/conf.d/zz-pcov.ini

# On first start the entrypoint copies WordPress into the volume, including wp-content/plugins and
# wp-content/themes, which are bind-mounted from the repo. Keep stock plugins and themes out of
# those folders so they never land in the working tree; stock themes get their own folder.
COPY stock-themes.php /usr/src/wordpress/wp-content/mu-plugins/stock-themes.php
RUN cd /usr/src/wordpress/wp-content \
    && rm -rf plugins/akismet plugins/hello.php plugins/index.php themes/index.php \
    && mv themes themes-stock \
    && mkdir themes

# The WordPress test library scans uploads; let the test container run as the host user.
RUN mkdir -p /usr/src/wordpress/wp-content/uploads \
    && chmod 1777 /usr/src/wordpress/wp-content/uploads
