#!/usr/bin/env bash

set -e

TEMPDIR=$(mktemp -d)

GOMAXPROCS=1 hugo --cacheDir /$TEMPDIR/hugo_kindrobot
