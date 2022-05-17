#!/usr/bin/env bash

set -eux

./build.sh
rsync -r public/* kindrobot@tilde.town:public_html
