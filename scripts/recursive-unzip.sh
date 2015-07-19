#!/bin/bash
# unzip all zips in current directory and every child directory.
find . -name '*.zip' -exec sh -c 'unzip -d `dirname {}` {}' ';'
