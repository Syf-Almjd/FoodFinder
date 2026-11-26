#!/bin/bash
# Exploration: screen size and visible UI nodes for FoodFinder (no taps yet).
echo "WM=$(adb shell wm size | tr -d '\r')"
adb shell am force-stop com.mjd.foodfinder
adb shell monkey -p com.mjd.foodfinder -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
sleep 14
adb shell uiautomator dump /sdcard/u.xml >/dev/null 2>&1
adb shell cat /sdcard/u.xml | tr '>' '>\n' | grep -o 'text="[^"]*"\|content-desc="[^"]*"\|bounds="[^"]*"\|class="[^"]*"' | paste -sd' ' | sed 's/class=/\nclass=/g' | grep -v 'text="" content-desc=""' | head -60
