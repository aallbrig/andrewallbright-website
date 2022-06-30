#!/usr/bin/env bash

# time vs /usr/bin/time
# https://superuser.com/questions/112353/how-can-i-give-arguments-to-time-command-ubuntu
dependencies=(bc curl /usr/bin/time)
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
    status_code=$( \
      curl \
        --head \
        --location \
        --silent \
        --output /dev/null \
        --write-out "%{http_code}" \
        "${url}" \
      2> /dev/null \
    )
    [[ -n "${DEBUG}" ]] && echo "http status code: ${status_code}"
    if [[ "${status_code}" -gt 200 ]] && [[ "${status_code}" -lt 300 ]] ; then
      echo "✅ $((++test_counter)) ${url} is alive and healthy (request status code ${status_code})"
    else
      echo "❌ $((++test_counter)) ${url} is not alive and healthy (request status code ${status_code})"
    fi
  done
}

check_website_is_fast_enough() {
  expected_timing_in_seconds=10
  for url in "${urls[@]}" ; do
    raw_timing_of_request=$(/usr/bin/time -h -p curl --silent --output /dev/null "${url}" &> /dev/stdout)
    [[ -n "${DEBUG}" ]] && echo "timing of command:"
    [[ -n "${DEBUG}" ]] && echo "${raw_timing_of_request}"

    time_in_seconds=$(echo "${raw_timing_of_request}" | grep 'real' | awk '{ print $2 }' | bc -l)
    [[ -n "${DEBUG}" ]] && echo "total time in seconds: ${time_in_seconds}"

    if (( $(echo "${expected_timing_in_seconds} > ${time_in_seconds}" | bc -l) )) ; then
      echo "✅ $((++test_counter)) ${url} time of ${time_in_seconds} meets expected time of ${expected_timing_in_seconds} seconds"
    else
      echo "❌ $((++test_counter)) ${url} time of ${time_in_seconds} FAILS to meet expected time of ${expected_timing_in_seconds} seconds"
    fi
  done
}

main() {
  check_script_dependencies
  check_website_alive
  check_website_is_fast_enough
}

main
