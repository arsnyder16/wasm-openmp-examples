#!/bin/bash -e
set -e

PROJECT_DIR=`realpath .`
EMSDK_DIR=$PROJECT_DIR/emsdk
BUILD_DIR=build-em
OPENMP_DIR=${OPENMP_DIR:=$PROJECT_DIR/llvm-project/openmp}
OPENMP_LIB=$BUILD_DIR/lib/libomp.a

mkdir -p $BUILD_DIR

./emsdk/emsdk install latest
./emsdk/emsdk activate latest
source $EMSDK_DIR/emsdk_env.sh

export CFLAGS="-pthread"
export CXXFLAGS="-pthread"
emcmake cmake \
    -DOPENMP_STANDALONE_BUILD=ON \
    -DOPENMP_ENABLE_OMPT_TOOLS=OFF \
    -DOPENMP_ENABLE_LIBOMPTARGET=OFF \
    -DLIBOMP_HAVE_OMPT_SUPPORT=OFF \
    -DLIBOMP_OMPT_SUPPORT=OFF \
    -DLIBOMP_OMPD_SUPPORT=OFF \
    -DLIBOMP_USE_DEBUGGER=OFF \
    -DLIBOMP_FORTRAN_MODULES=OFF \
    -DLIBOMP_ENABLE_SHARED=OFF \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR \
    -B $BUILD_DIR \
    -S $OPENMP_DIR

emmake make -C $BUILD_DIR -j
emmake make install -C $BUILD_DIR

echo
echo "!!! adjust clang being used you will need to update the clang in $EMSDK_DIR/upstream/bin !!!"
echo

echo "Building example..."

emcc -I$BUILD_DIR/include $OPENMP_LIB -fopenmp=libomp -pthread example.c other.c -o $BUILD_DIR/example.js

echo "Running example..."
node $BUILD_DIR/example.js