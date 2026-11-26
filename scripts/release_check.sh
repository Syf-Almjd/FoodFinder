#!/bin/bash
# Installs the CI-signed RELEASE apk, launches it and screenshots it. Optional second arg "back":
# portfolio navigation test (tap, back, back-to-exit).
PKG="$1"; MODE="$2"; mkdir -p shots
adb uninstall "$PKG" >/dev/null 2>&1
adb install -r build/app/outputs/flutter-apk/app-release-ci.apk || { echo "::error::release install failed"; exit 1; }
adb logcat -c
adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
sleep 20; adb exec-out screencap -p > shots/rel_1.png
echo "REL focus=$(adb shell dumpsys window 2>/dev/null | grep -m1 mCurrentFocus | tr -d '\r' | cut -c1-110) pid=$(adb shell pidof $PKG | tr -d '\r')"
if [ "$MODE" = back ]; then
  adb shell input tap 160 455; sleep 5; adb exec-out screencap -p > shots/rel_2.png
  echo "REL after tap focus=$(adb shell dumpsys window 2>/dev/null | grep -m1 mCurrentFocus | tr -d '\r' | cut -c1-110)"
  adb shell input keyevent 4; sleep 4; adb exec-out screencap -p > shots/rel_3.png
  echo "REL after back1 focus=$(adb shell dumpsys window 2>/dev/null | grep -m1 mCurrentFocus | tr -d '\r' | cut -c1-110) pid=$(adb shell pidof $PKG | tr -d '\r')"
  adb shell input keyevent 4; sleep 4; adb exec-out screencap -p > shots/rel_4.png
  echo "REL after back2 focus=$(adb shell dumpsys window 2>/dev/null | grep -m1 mCurrentFocus | tr -d '\r' | cut -c1-110) pid=$(adb shell pidof $PKG | tr -d '\r')"
fi
adb logcat -d > shots/rel_logcat.txt 2>/dev/null
echo "REL_FATAL=$(grep -c 'FATAL EXCEPTION' shots/rel_logcat.txt)"
for f in $(ls shots/rel_*.png | sort); do echo "B64_BEGIN $f"; base64 -w0 "$f"; echo; echo "B64_END $f"; done
