fresh_dev_environment() {
  docker-compose --file docker-compose/local-stack.yaml build
  docker-compose --file docker-compose/local-stack.yaml up --detach
}

notify_user_of_available_http_urls() {
  ports=$(docker ps --filter name="docker-compose_website_nginx_1" --format '{{ .Ports }}')
  [[ -n "${DEBUG}" ]] && echo "(debug) ports: ${ports}"

  http_host_port=$(echo "${ports}" | sed -n "s/^.*0.0.0.0:\(.*\)..80.tcp.*$/\1/p")
  [[ -n "${DEBUG}" ]] && echo "(debug) http_host_port: ${http_host_port}"

  # Output for user
  echo "available website located: http://localhost:${http_host_port}"
}

main() {
  fresh_dev_environment
  notify_user_of_available_http_urls
}

main
