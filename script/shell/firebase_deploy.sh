#!/bin/bash
set -e

./script/shell/cleanup.sh
source ./script/shell/ruby_path_detector.sh

cd android
bundle exec fastlane to_firebase
gen clean fastlane/build fastlane/report.xml fastlane/README.md


