#!/bin/bash
set -e

./cleanup.sh

cd android
bundle exec fastlane to_google_drive
gen clean fastlane/build fastlane/report.xml fastlane/README.md

