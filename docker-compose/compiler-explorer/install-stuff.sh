#!/bin/bash

set -ex

COMPILER_EXPLORER_COMMIT=${COMPILER_EXPLORER_COMMIT:-'8463590186248dd4fabedc06e8957b5255efb3f0'}
declare -a ITEMS=(
	# tools required for compiler-explorer
	'compilers/c++/nightly/clang trunk'
	'compilers/c++/nightly/gcc trunk'
	'tools/iwyu 0.12'
	'tools/pahole trunk'
	'tools/osaca 0.5.2'  # requires python3.8

	# compilers/libraries for use
	'compilers/c++/x86/gcc 4.9.4'
	'compilers/c++/x86/gcc 5.5.0'
	'compilers/c++/x86/gcc 6.4.0'
	'compilers/c++/x86/gcc 7.5.0'
	'compilers/c++/x86/gcc 8.5.0'
	'compilers/c++/x86/gcc 9.5.0'
	'compilers/c++/x86/gcc 10.5.0'
	'compilers/c++/x86/gcc 11.4.0'
	'compilers/c++/x86/gcc 12.3.0'
	'compilers/c++/x86/gcc 13.2.0'
	'compilers/c++/clang 9.0.1'
	'compilers/c++/clang 10.0.1'
	'compilers/c++/clang 11.0.1'
	'compilers/c++/clang 12.0.1'
	'compilers/c++/clang 13.0.1'
	'compilers/c++/clang 14.0.0'
	'compilers/c++/clang 15.0.0'
	'compilers/c++/clang 16.0.0'
	'compilers/c++/clang 17.0.1'
	'compilers/c++/clang 18.1.0'
	'libraries/c++/boost 1.64.0'
	'libraries/c++/boost 1.65.0'
	'libraries/c++/boost 1.66.0'
	'libraries/c++/boost 1.67.0'
	'libraries/c++/boost 1.68.0'
	'libraries/c++/boost 1.69.0'
	'libraries/c++/boost 1.70.0'
	'libraries/c++/boost 1.71.0'
	'libraries/c++/boost 1.72.0'
	'libraries/c++/boost 1.73.0'
	'libraries/c++/boost 1.74.0'
	'libraries/c++/boost 1.75.0'
	'libraries/c++/boost 1.76.0'
	'libraries/c++/boost 1.77.0'
	'libraries/c++/boost 1.78.0'
	'libraries/c++/boost 1.79.0'
	'libraries/c++/boost 1.80.0'
	'libraries/c++/boost 1.81.0'
	'libraries/c++/boost 1.82.0'
	'libraries/c++/boost 1.83.0'
	'libraries/c++/boost 1.84.0'
	'tools/cmake 3.26.1'
	'tools/cmake 3.27.9'
	'tools/cmake 3.28.0'
	'compilers/python 3.5.9'
	'compilers/python 3.6.10'
	'compilers/python 3.7.6'
	'compilers/python 3.8.1'
	'compilers/python 3.9.6'
	'compilers/python 3.10.0'
	'compilers/python 3.11.0'
	'compilers/python 3.12.1'
	'compilers/asm/nasm 2.12.02'
	'compilers/asm/nasm 2.13.02'
	'compilers/asm/nasm 2.13.03'
	'compilers/asm/nasm 2.14.02'
	'compilers/asm/nasm 2.16.01'
)

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl wget ca-certificates make git vim libstdc++6 xz-utils bzip2 python3-pip python3-pip-whl software-properties-common firejail binutils

# Install nodejs
curl -sL 'https://deb.nodesource.com/setup_20.x' | bash -
apt-get install -y nodejs

# WORKAROUND: Install python 3.8 for 'osaca'
add-apt-repository 'ppa:deadsnakes/ppa' -y
apt-get update -y
apt-get install -y python3.8 python3.8-venv

# Cleanup apt-get
apt-get autoremove --purge -y
apt-get autoclean -y
rm -rf /var/cache/apt/* /tmp/*

# Install compilers/tools
git clone --branch 'main' --depth 1 --single-branch 'https://github.com/compiler-explorer/infra.git' '/tmp/infra'
cd '/tmp/infra'
make ce
for item in "${ITEMS[@]}"; do
	'./bin/ce_install' --enable nightly install "$item"
done
cd '/'
rm -fr '/tmp/infra'

# Install compiler-explorer
git clone 'https://github.com/compiler-explorer/compiler-explorer.git' '/compiler-explorer'
cd '/compiler-explorer'
git checkout "${COMPILER_EXPLORER_COMMIT}"
mv '/compiler-explorer/etc/config/sponsors.yaml' '/tmp/sponsors.yaml'
mv '/compiler-explorer/etc/config/site-templates.conf' '/tmp/site-templates.conf'
rm -fr '/compiler-explorer/etc/config/'
mkdir -p '/compiler-explorer/etc/config/'
mv '/tmp/sponsors.yaml' '/compiler-explorer/etc/config/sponsors.yaml'
mv '/tmp/site-templates.conf' '/compiler-explorer/etc/config/site-templates.conf'
mkdir -p '/compiler-explorer/out/dist/examples'
make prebuild
