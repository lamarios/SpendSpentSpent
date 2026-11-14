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
update-goldens:
	flutter test --update-goldens

# AVD name:local port of each emulator's remote control MCP server (port 8080 on the device).
# Emulators are matched by AVD name because their serials change between starts.
MCP_FORWARDS ?= Pixel_9_Pro_XL:18080 Pixel_Tablet:18081
forward-mcp:
	@for serial in $$(adb devices | awk 'NR>1 && $$2=="device" {print $$1}'); do \
		avd=$$(adb -s $$serial emu avd name 2>/dev/null | head -1 | tr -d '\r'); \
		for mapping in $(MCP_FORWARDS); do \
			if [ "$${mapping%%:*}" = "$$avd" ]; then \
				adb -s $$serial forward tcp:$${mapping##*:} tcp:8080 >/dev/null && \
				echo "$$avd ($$serial) -> 127.0.0.1:$${mapping##*:}"; \
			fi; \
		done; \
	done