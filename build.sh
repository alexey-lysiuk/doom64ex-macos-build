#!/bin/sh

# Configuration

CONFIG=Release
DEPLOY_DIR=../deploy
SRC_BUNDLE=src/engine/${CONFIG}/doom64ex.app
DST_BUNDLE=${DEPLOY_DIR}/Doom64EX.app
DST_RES_DIR=${DST_BUNDLE}/Contents/Resources
KEX_WAD=kex.wad

set -o errexit

cd "`dirname \"$0\"`"
./prepare.sh

cd build
xcodebuild -configuration "${CONFIG}" -target doom64ex -target kexwad

if [ ! -e "${DST_RES_DIR}" ]; then
	mkdir -p "${DST_RES_DIR}"
fi

rsync -av "${SRC_BUNDLE}/" "${DST_BUNDLE}"
rsync -av kex.wad "${DST_RES_DIR}"
