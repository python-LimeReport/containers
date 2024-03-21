#!/bin/sh

BASE_FOLDER="/qt-patches"

echo "Qt version: $QT_VERSION"

# if qt verion is 6.5.3 apply fix
if [ "$QT_VERSION" = "6.5.3" ]; then
    echo "Apply fix-build-vaappi-version-1.9.0.diff"
    patch -p1 < "$BASE_FOLDER/fix-build-vaappi-version-1.9.0.diff"
fi