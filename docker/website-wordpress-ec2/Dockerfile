# Expectation: Amazon linux is the target OS of the andrew allbright website.
FROM amazonlinux:latest

RUN amazon-linux-extras install -y nginx1 php7.4 mariadb10.5

# Below appropriate for entrypoint script?
# Install andrewallbright-wordpress
# Install andrewallbright-wordpress cli
# execute configuration commands on andrewallbright-wordpress

COPY nginx/etc/nginx/conf.d /etc/nginx/conf.d
COPY nginx/usr/share/nginx/andrewallbright-wordpress /usr/share/nginx/andrewallbright-wordpress

RUN chown -R nginx:nginx /usr/share/nginx/*

COPY php-fpm/etc/php-fpm.conf /etc/php-fpm.conf
COPY php-fpm/etc/php-fpm.d /etc/php-fpm.d

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && php wp-cli.phar --info \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

ADD docker/website-wordpress-ec2/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443
VOLUME ["/usr/share/nginx/andrewallbright-wordpress", "/etc/php-fpm.conf", "/etc/php-fpm.d", "/etc/nginx/conf.d"]

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "/entrypoint.sh"]
