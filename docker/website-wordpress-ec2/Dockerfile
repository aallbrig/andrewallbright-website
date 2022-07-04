# Expectation: Amazon linux is the target OS of the andrew allbright website.
FROM amazonlinux:latest

RUN amazon-linux-extras install -y nginx1 php7.4

# Below appropriate for entrypoint script?
# Install wordpress
# Install wordpress cli
# execute configuration commands on wordpress

ADD docker/website-wordpress-ec2/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY nginx/etc/nginx/conf.d /etc/nginx/conf.d
COPY nginx/usr/share/nginx/wordpress /usr/share/nginx/wordpress

RUN chown -R nginx:nginx /usr/share/nginx/*

COPY php-fpm/etc/php-fpm.conf /etc/php-fpm.conf
COPY php-fpm/etc/php-fpm.d /etc/php-fpm.d

EXPOSE 80 443
VOLUME ["/usr/share/nginx/wordpress", "/etc/php-fpm.conf", "/etc/php-fpm.d", "/etc/nginx/conf.d"]

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "/entrypoint.sh"]
