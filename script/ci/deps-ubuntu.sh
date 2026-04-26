#!/usr/bin/env bash
set -e

GCC_VERSION=13

sudo add-apt-repository ppa:ubuntu-toolchain-r/test || :
sudo apt-get update || :
sudo apt-get install
  bison flex curl make texinfo zlib1g-dev tar bzip2 gzip xz-utils unzip \
  dos2unix libtool-bin gcc-$GCC_VERSION g++-$GCC_VERSION cmake help2man \
  python3-dev nasm libslang2-dev ccache

echo "CC=gcc-$GCC_VERSION" >> $GITHUB_ENV
echo "CXX=g++-$GCC_VERSION" >> $GITHUB_ENV
mkdir -p $HOME/.ccache
echo "CCACHE_DIR=$HOME/.ccache" >> $GITHUB_ENV
echo "/usr/lib/ccache" >> $GITHUB_PATH
