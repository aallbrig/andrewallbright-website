#!/usr/bin/env bash

dependencies=(nginx)

check_script_dependencies() {
  # ☑️ Script dependencies are found
  for required_executable in "${dependencies[@]}" ; do
    if ! command -v "${required_executable}" > /dev/null ; then
      echo "❌ required executable \"${required_executable}\" is not defined"
      exit 1
    fi
  done
}

start_nginx_server() {
  # initialize nginx
  nginx -g 'daemon off;'
}

main() {
  check_script_dependencies
  start_nginx_server
}

main
