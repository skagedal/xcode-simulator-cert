#!/bin/bash

# This should be executed as a build phase in Xcode

mint run swiftlint swiftlint autocorrect --path Sources
mint run swiftlint swiftlint --path Sources
