#!/bin/bash

# Source: http://blog.nonuby.com/blog/2012/07/05/copying-env-vars-from-one-heroku-app-to-another/

set -e

sourceApp="$1"
targetApp="$2"
config=""

while read line; do
  config="$config $line"
done  < <(heroku config --remote "$sourceApp" --shell )

eval "heroku config:set $config --remote $targetApp"
