#!/bin/bash
# Signs the release APK with a throwaway key generated inside this CI run so it can be installed on the
# emulator. The key and password exist only in this runner and are never saved or uploaded.
set -e
IN=build/app/outputs/flutter-apk/app-release.apk
PW=$(openssl rand -hex 12)
KS=$(mktemp -u).jks
keytool -genkeypair -keystore "$KS" -storepass "$PW" -keypass "$PW" -alias ci -dname "CN=ci" -keyalg RSA -keysize 2048 -validity 2 >/dev/null 2>&1
BT=$(ls -d "$ANDROID_HOME"/build-tools/* | sort -V | tail -1)
"$BT/zipalign" -f -p 4 "$IN" /tmp/aligned.apk
"$BT/apksigner" sign --ks "$KS" --ks-pass "pass:$PW" --out build/app/outputs/flutter-apk/app-release-ci.apk /tmp/aligned.apk
rm -f "$KS"
ls -la build/app/outputs/flutter-apk/app-release-ci.apk
