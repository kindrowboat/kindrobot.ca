#!/usr/bin/env bash

set -e

tmpdir=$(mktemp -d)

GOMAXPROCS=1 hugo --cacheDir "$tmpdir"
