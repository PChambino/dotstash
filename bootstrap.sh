#!/bin/sh
set -e
homebrew/install.sh
for SCRIPT in */link.sh; do $SCRIPT; done
