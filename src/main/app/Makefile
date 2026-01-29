export PATH := $(shell pwd)/submodules/flutter/bin:$(PATH)
# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
THIS_FILE := $(lastword $(MAKEFILE_LIST))

build-runner:
	dart run build_runner build --delete-conflicting-outputs
build-runner-watch:
	dart run build_runner watch --delete-conflicting-outputs
send-notification-to-device:
	adb shell cmd notification post -S bigtext -t 'Title' 'Tag' '2.30'