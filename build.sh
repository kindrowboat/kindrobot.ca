#!/usr/bin/env bash

set -e

GOMAXPROCS=1 hugo --cacheDir /$TMPDIR/hugo_kindrobot
