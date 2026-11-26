#!/bin/bash
# FoodFinder UI flow via adb taps (screen 320x640). Search, open dish, favorite, Favorites tab. No ad taps.
P=com.mjd.foodfinder; mkdir -p shots
snap(){ sleep 3; adb exec-out screencap -p > "shots/flow_$1.png"; adb shell uiautomator dump /sdcard/u.xml >/dev/null 2>&1; echo "STEP $1 focus=$(adb shell dumpsys window 2>/dev/null | grep -m1 mCurrentFocus | tr -d '\r' | cut -c1-90) pid=$(adb shell pidof $P | tr -d '\r')"; adb shell cat /sdcard/u.xml | grep -o 'content-desc="[^"]\+"' | tr '\n' ' ' | cut -c1-400; echo; }
adb logcat -c
adb shell am force-stop $P
adb shell monkey -p $P -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
sleep 14; snap 1_home
adb shell input tap 160 173; sleep 1; adb shell input text "pan"; sleep 1; adb shell input keyevent 66; snap 2_search
adb shell input tap 140 245; snap 3_details
sleep 8
adb shell uiautomator dump /sdcard/u.xml >/dev/null 2>&1
XY=$(adb shell cat /sdcard/u.xml | tr '>' '\n' | grep 'Add to Favourite' | grep -o 'bounds="\[[0-9]*,[0-9]*\]\[[0-9]*,[0-9]*\]"' | head -1 | python3 -c "import re,sys;m=re.findall(r'\d+',sys.stdin.read());print((int(m[0])+int(m[2]))//2,(int(m[1])+int(m[3]))//2) if len(m)==4 else print('')")
echo "FAV_XY=$XY"
[ -n "$XY" ] && adb shell input tap $XY
snap 4_fav_added
adb shell input keyevent 4; sleep 2; snap 5_back
adb shell input tap 218 523; snap 6_favorites_tab
adb logcat -d > shots/flow_logcat.txt 2>/dev/null
echo "FLOW_FATAL=$(grep -c 'FATAL EXCEPTION' shots/flow_logcat.txt)"
for f in $(ls shots/flow_[456]*.png | sort); do echo "B64_BEGIN $f"; base64 -w0 "$f"; echo; echo "B64_END $f"; done
