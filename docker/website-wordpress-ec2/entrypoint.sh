#!/usr/bin/env bash

dependencies=(nginx php-fpm mysqld_safe)

check_script_dependencies() {
  # ☑️ Script dependencies are found
  for required_executable in "${dependencies[@]}" ; do
    if ! command -v "${required_executable}" > /dev/null ; then
      echo "❌ required executable \"${required_executable}\" is not defined"
      exit 1
    fi
  done
}

start_php_interpreter() {
  php-fpm
}

start_nginx_server() {
  nginx
}

start_mariadb() {
  mysqld_safe
}

follow_all_log_files_forever() {
  tail -f \
    /var/log/nginx/access.log \
    /var/log/nginx/error.log \
    /var/log/php-fpm/error.log \
    /var/log/mariadb/mariadb.log
}

sleep_forever() {
  /bin/bash -c "trap : TERM INT; sleep infinity & wait"
}

run_forever() {
  follow_all_log_files_forever
}

main() {
  check_script_dependencies
  start_mariadb
  start_php_interpreter
  start_nginx_server

  run_forever # or until process kill
}

main
