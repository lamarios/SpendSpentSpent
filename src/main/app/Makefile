export PATH := $(shell pwd)/submodules/flutter/bin:$(PATH)
# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
THIS_FILE := $(lastword $(MAKEFILE_LIST))

build-runner:
	dart run build_runner build --delete-conflicting-outputs lib
build-runner-watch:
	dart run build_runner watch --delete-conflicting-outputs lib
