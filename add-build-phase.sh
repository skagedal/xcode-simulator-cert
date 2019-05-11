#!/bin/bash

mint run xcodeproj-modify xcodeproj-modify ./xcode-simulator-tool.xcodeproj add-run-script-phase xcode-simulator-tool ./xcode-build-phase.sh
