#!/bin/sh

CMAKE_EXE=`which cmake`

if [ -z $CMAKE_EXE ]; then
	CMAKE_EXE=/Applications/CMake.app/Contents/bin/cmake
fi

set -o errexit

cd "`dirname \"$0\"`"

TP_DIR=`pwd`/thirdparty
SDL2_DIR=${TP_DIR}/SDL2
SDL2_NET_DIR=${TP_DIR}/SDL2_net
PNG_DIR=${TP_DIR}/png
FLUIDSYNTH_DIR=${TP_DIR}/fluidsynth
FLUIDSYNTH_LIB_PREFIX=${FLUIDSYNTH_DIR}/lib/lib
GTEST_DIR=${TP_DIR}/gtest
GTEST_LIB_PREFIX=${GTEST_DIR}/lib/libgtest

if [ -e Doom64EX ]; then
	cd Doom64EX
	git pull
	cd ..
else
	git clone https://github.com/svkaiser/Doom64EX.git
fi

if [ ! -e build ]; then
	mkdir build
fi

cd build

$CMAKE_EXE ../Doom64EX -GXcode \
	-DCMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY="libc++" \
	-DCMAKE_OSX_DEPLOYMENT_TARGET="10.7" \
	-DGTEST_INCLUDE_DIR="${GTEST_DIR}/include" \
	-DGTEST_LIBRARY="${GTEST_LIB_PREFIX}.a" \
	-DGTEST_MAIN_LIBRARY="${GTEST_LIB_PREFIX}_main.a" \
	-DSDL2_INCLUDE_DIR="${SDL2_DIR}/include" \
	-DSDL2_LIBRARY="${SDL2_DIR}/lib/libSDL2.a" \
	-DSDL2_NET_INCLUDE_DIR="${SDL2_NET_DIR}/include" \
	-DSDL2_NET_LIBRARY="${SDL2_NET_DIR}/lib/libSDL2_net.a" \
	-DPNG_PNG_INCLUDE_DIR="${PNG_DIR}/include" \
	-DPNG_LIBRARY_DEBUG="${PNG_DIR}/lib/libpng16.a" \
	-DPNG_LIBRARY_RELEASE="${PNG_DIR}/lib/libpng16.a" \
	-DFLUIDSYNTH_INCLUDE_DIR="${FLUIDSYNTH_DIR}/include" \
	-DFLUIDSYNTH_LIBRARIES="${FLUIDSYNTH_LIB_PREFIX}fluidsynth.a;${FLUIDSYNTH_LIB_PREFIX}glib.a;${FLUIDSYNTH_LIB_PREFIX}intl.a" \
	-DCMAKE_EXE_LINKER_FLAGS="-framework AudioUnit -framework Carbon -framework Cocoa -framework CoreAudio -framework CoreMIDI -framework CoreVideo -framework ForceFeedback -framework IOKit -liconv"
