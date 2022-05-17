#!/usr/bin/env bash

set -e

GOMAXPROCS=1 hugo --cacheDir /tmp/hugo_kindrobot
