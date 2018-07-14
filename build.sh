#!/bin/sh

# Configuration

CONFIG=Release
DEPLOY_DIR=../deploy
SRC_BUNDLE=${CONFIG}/doom64ex.app
DST_BUNDLE=${DEPLOY_DIR}/Doom64EX.app
DST_RES_DIR=${DST_BUNDLE}/Contents/Resources
RES_FILE=doom64ex.pk3
INFO_PLIST_PATH=${DST_BUNDLE}/Contents/Info.plist

set -o errexit

cd "`dirname \"$0\"`"
./prepare.sh

cd build
xcodebuild -configuration "${CONFIG}"

if [ ! -e "${DST_RES_DIR}" ]; then
	mkdir -p "${DST_RES_DIR}"
fi

rsync -av "${SRC_BUNDLE}/" "${DST_BUNDLE}"
rsync -av "${RES_FILE}" "${DST_RES_DIR}"

plutil -replace LSMinimumSystemVersion -string "10.7" "${INFO_PLIST_PATH}"
plutil -replace NSPrincipalClass -string "NSApplication" "${INFO_PLIST_PATH}"
plutil -replace NSSupportsAutomaticGraphicsSwitching -bool YES "${INFO_PLIST_PATH}"
