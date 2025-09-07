#!/bin/bash
set -e

NCORES=$(nproc)

build_binutils() {
	cd build-binutils
	../dirty/binutils-2.45/configure --target=x86_64-pc-ethos --prefix=$(pwd);
	make -j$(NCORES)
	make install

	cd ../
	echo "[?] binutils is in build-binutils/"
}

if [[ -d build-binutils/ ]]
then
	echo "build-binutils/ already exists, rebuilding..."
	build_binutils
	exit 0
fi

# Clean everything up
echo "Cleaning up..."
rm -rf clean/clean build/ dirty/

# Extract the clean sources
echo "Extracting binutils..."
cd clean/
tar -xzvf binutils-2.45.gz
cd ../

# Patch binutils
echo "Patching binutils..."
mkdir -p dirty/
cp -r clean/clean/* dirty/
patch -s -p0 < patches/binutils-2.45.patch
rm -rf clean/clean/

# Build binutils
echo "Building binutils"
mkdir -p build-binutils/
build_binutils
