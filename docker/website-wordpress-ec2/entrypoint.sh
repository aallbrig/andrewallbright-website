#!/usr/bin/env bash

dependencies=(nginx php)

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
  php -v
}

start_nginx_server() {
  # initialize nginx
  nginx
}

follow_all_log_files() {
  tail -f /var/log/nginx/access.log /var/log/nginx/error.log
}

sleep_forever() {
  /bin/bash -c "trap : TERM INT; sleep infinity & wait"
}

run_forever() {
  follow_all_log_files
}

main() {
  check_script_dependencies
  start_php_interpreter
  start_nginx_server

  # or until process kill
  run_forever
}

main
