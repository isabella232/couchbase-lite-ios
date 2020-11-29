#!/bin/sh

#  build-xcframework.sh
#
#  Created by Kevin Cao on 2019/10/15.
#  Copyright © 2019 Sumi Interactive. All rights reserved.

PROJECT="CouchbaseLite"
SCHEME="CBL iOS framework - Carthage"
BUILD_DIR="build"
TMP_DIR=${BUILD_DIR}/"tmp"

mkdir -p ${TMP_DIR}

echo "Building ${PROJECT} for iOS..."
xcodebuild archive \
    -configuration "Release" \
    -project ${PROJECT}.xcodeproj \
    -scheme "${SCHEME}" \
    -destination "generic/platform=iOS" \
    -archivePath ${TMP_DIR}/${PROJECT}-iphoneos.xcarchive \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

echo "Building ${PROJECT} for iOS Simulator..."
xcodebuild archive \
    -configuration "Release" \
    -project ${PROJECT}.xcodeproj \
    -scheme "${SCHEME}" \
    -destination "generic/platform=iOS Simulator" \
    -archivePath ${TMP_DIR}/${PROJECT}-iphonesimulator.xcarchive \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

echo "Building ${PROJECT} for macOS..."
xcodebuild archive \
    -configuration "Release" \
    -project ${PROJECT}.xcodeproj \
    -scheme "${SCHEME}" \
    -destination "generic/platform=macOS,variant=Mac Catalyst,name=Any Mac" \
    -archivePath ${TMP_DIR}/${PROJECT}-macosx.xcarchive \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
    SUPPORTS_MACCATALYST=YES

echo "Building ${PROJECT}.xcframework"
xcodebuild -create-xcframework \
    -framework ${TMP_DIR}/${PROJECT}-iphoneos.xcarchive/Products/Library/Frameworks/${PROJECT}.framework \
    -framework ${TMP_DIR}/${PROJECT}-iphonesimulator.xcarchive/Products/Library/Frameworks/${PROJECT}.framework \
    -framework ${TMP_DIR}/${PROJECT}-macosx.xcarchive/Products/Library/Frameworks/${PROJECT}.framework \
    -output ${TMP_DIR}/${PROJECT}.xcframework

rm -rf ${BUILD_DIR}/${PROJECT}.xcframework
mv -f ${TMP_DIR}/${PROJECT}.xcframework ${BUILD_DIR}/${PROJECT}.xcframework
rm -rf ${TMP_DIR}
