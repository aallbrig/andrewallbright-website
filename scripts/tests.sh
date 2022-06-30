#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

main() {
  bash "${SCRIPT_DIR}"/tests/infrastructure-tests.sh
  bash "${SCRIPT_DIR}"/tests/website-tests.sh
}

main
