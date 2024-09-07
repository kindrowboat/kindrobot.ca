#!/usr/bin/env bash
set -eu

# if a codespace is named "turbo-capybara-4xvj57765fv4g", the site is served out
# of "/~kindrobot", and hugo uses port 1313 for serving a development page, then
# the hugo serve commend will need to be:
# `hugo serve --baseURL=https://turbo-capybara-4xvj57765fv4g-1313.app.github.dev --port=1313 --appendPort=false`

BASE_PATH="~kindrobot"
SERVE_PORT=1313
BASE_URL="https://${CODESPACE_NAME}-${SERVE_PORT}.app.github.dev/${BASE_PATH}"

hugo serve --baseURL=${BASE_URL} --port=${SERVE_PORT} --appendPort=false
