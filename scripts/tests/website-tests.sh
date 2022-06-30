#!/usr/bin/env bash

message=""
# time vs /usr/bin/time
# https://superuser.com/questions/112353/how-can-i-give-arguments-to-time-command-ubuntu
dependencies=(curl /usr/bin/time)
urls=("https://andrewallbright.com" "https://www.andrewallbright.com")


check_script_dependencies() {
  # ☑️ Script dependencies are found
  for required_executable in "${dependencies[@]}" ; do
    if ! which "${required_executable}" > /dev/null ; then
      echo "❌ required executable \"${required_executable}\" is not defined"
      exit 1
    fi
  done
}

check_website_alive() {
  for url in "${urls[@]}" ; do
    message="Health of ${url}"
    if curl "${url}" &> /dev/null ; then
      message="✅ $((++test_counter)) ${message}"
    else
      message="❌ $((++test_counter)) ${message}"
    fi
    echo "${message}"
  done
}

check_website_is_fast_enough() {
  for url in "${urls[@]}" ; do
    message="Checking performance of ${url}"
    timing=$(/usr/bin/time -h curl "${url}" &> /dev/null)
    echo "${timing}"
    if false ; then
      message="✅ $((++test_counter)) ${message}"
    else
      message="❌ $((++test_counter)) ${message}"
    fi
    echo "${message}"
  done
}

main() {
  check_script_dependencies
  check_website_alive
  check_website_is_fast_enough
}

main
