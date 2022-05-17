#!/usr/bin/env bash

set -eux

hugo
rsync -r public/* kindrobot@tilde.town:public_html
