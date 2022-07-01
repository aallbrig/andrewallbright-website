# Expectation: Amazon linux is the target OS of the andrew allbright website.
FROM amazonlinux:latest

RUN amazon-linux-extras install -y nginx1 php7.4
RUN amazon-linux-extras enable -y nginx1 php7.4

# Below appropriate for entrypoint script?
# Install wordpress
# Install wordpress cli
# execute configuration commands on wordpress

ADD docker/website-wordpress-ec2/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443
VOLUME ["/usr/share/nginx/wordpress", "/etc/nginx/conf.d"]

RUN chown nginx:nginx /usr/share/nginx/*

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/entrypoint.sh"]
