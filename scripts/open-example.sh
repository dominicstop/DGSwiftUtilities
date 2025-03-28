#!/bin/bash
killall Xcode
export $(grep -v '^#' .env | xargs) ; open ./Example/*.xcodeproj