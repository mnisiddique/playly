#!/bin/bash
set -e

fvm flutter clean
fvm flutter pub get
fvm dart run build_runner build -d