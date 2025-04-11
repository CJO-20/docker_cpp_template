#!/bin/bash
sh clean_up.sh
conan profile detect --force
mkdir build
conan install . --output-folder=build --build=missing
cd build
cmake .. --preset conan-release
cmake --build .
mv install ..
cd ..
