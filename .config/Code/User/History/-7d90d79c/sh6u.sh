#!/bin/bash

#Remove all node_modules directories
find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +

#Remove all dist
find . -name 'dist' -type d -prune -exec rm -rf '{}' +

#Remove log files
find . -name '*.log' -type f -delete


#Remove coverage directories
find . -name 'coverage' -type d -prune -exec rm -rf '{}'

#Remove lock file
find . -name 'package-lock.json' -type f -delete

#Remove tmp directories
find . -name 'tmp' -type d -prune -exec rm -rf '{}'

#Remove .nx directories
find . -name '.nx' -type d -prune -exec rm -rf '{}'