#!/usr/bin/env bash

urls=("https://andrewallbright.com" "https://www.andrewallbright.com")
dependencies=(curl)
message=""

# ☑️ Script dependencies are found
for required_executable in "${dependencies[@]}" ; do
  if ! which "${required_executable}" > /dev/null ; then
    echo "❌ required executable \"${required_executable}\" is not defined"
    exit 1
  fi
done

for url in "${urls[@]}" ; do
  message="Able to interact with URL ${url}"
  if curl "${url}"> /dev/null ; then
    message="✅ $((++test_counter)) ${message}"
  else
    message="❌ $((++test_counter)) ${message}"
  fi
  echo "${message}"
done
