# Expectation: Amazon linux is the target OS of the andrew allbright website.
FROM amazonlinux:latest

RUN amazon-linux-extras install -y nginx1 php7.4
RUN amazon-linux-extras enable -y nginx1

ADD docker/website-wordpress-ec2/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/entrypoint.sh"]
