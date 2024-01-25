#!/bin/bash

# Install required libraries
brew install openblas
brew install opencv3 --with-contrib --with-python3 --without-python
brew install cmake
brew install gtk+3 boost
brew install boost-python --with-python3

# Install XQuartz
# Note: This requires manual installation from https://www.xquartz.org

# Make soft link for X11
sudo ln -s /opt/X11 /usr/local/opt/X11

# Install dlib
git clone https://github.com/davisking/dlib.git
cd dlib
mkdir build
cd build
cmake .. -DUSE_SSE4_INSTRUCTIONS=ON
cmake --build . --config Release
cd ..
sudo python3 setup.py install
