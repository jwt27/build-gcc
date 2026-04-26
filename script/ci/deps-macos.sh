#!/usr/bin/env bash
set -e

brew update || :
brew install --formula \
  bash curl make texinfo gzip xz dos2unix libtool cmake help2man nasm \
  s-lang ccache

mkdir -p $HOME/.ccache
echo "CCACHE_DIR=$HOME/.ccache" >> $GITHUB_ENV
echo "$(brew --prefix)/opt/ccache/libexec" >> $GITHUB_PATH
