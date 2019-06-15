#!/bin/bash

mint run xcodeproj-modify xcodeproj-modify ./xcode-simulator-cert.xcodeproj add-run-script-phase xcode-simulator-cert ./xcode-build-phase.sh
