#!/bin/bash

if [[ -z "${API_KEY}" ]] || [[ -z "${API_SECRET}" ]] || [[ -z "${ACCESS_TOKEN}" ]] || [[ -z "${ACCESS_SECRET}" ]] || [[ -z "${APP_NAME}" ]]; then
  echo "Credential variables not set properly. Exiting."
  exit 1;
else
  echo "Creating twitter_credentials.R file."
  mv credentials/twitter_credentials_env_template.R credentials/twitter_credentials.R

  echo "Running application."
  R -e "shiny::runApp('app', host = '0.0.0.0', port = 3838)"
fi