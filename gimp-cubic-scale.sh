#!/usr/bin/env bash

find . -maxdepth 1 -name '*.png' |
  xargs printf '(gimp-cubic-scale "%s" 2.0)\n' |
  gimp -i  -b -
