host_http_port=${HOST_HTTP_PORT-=8080}
host_https_port=${HOST_HTTPS_PORT-=8443}

docker run -d -p "${host_http_port}":80 -p "${host_https_port}":443 andrewallbright-website
