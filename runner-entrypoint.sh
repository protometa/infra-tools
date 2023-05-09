#!/usr/bin/env bash
set -e

if [ -z "$RUNNER_TOKEN" ]
then
  echo "Must define RUNNER_TOKEN variable"
  exit 255
fi

# Reconfigure from the clean state in case of runner failures/restarts
./config.sh remove --token "${RUNNER_TOKEN}"
./config.sh --unattended --url "https://github.com/${GH_ORG}" --token "${RUNNER_TOKEN}"

exec "./run.sh" "${RUNNER_ARGS}"
