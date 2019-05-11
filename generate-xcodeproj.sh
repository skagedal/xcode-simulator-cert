#!/bin/bash

# This script should be run to generate the Xcode project.

# Generate xcodeproj

swift package generate-xcodeproj 

# Set header template.

sed s/CURRENTYEAR/`date +%Y`/g > xcode-simulator-tool.xcodeproj/xcshareddata/IDETemplateMacros.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>FILEHEADER</key>
	<string>
//  Copyright © CURRENTYEAR Simon Kågedal Reimer. See LICENSE.
//</string>
</dict>
</plist>
EOF

echo Please open xcode-simulator-tool.xcodeproj in Xcode.
echo Then close it.
echo Then run ./add-build-phase.sh
echo Then open it again.
echo 'Edit Build Settings and make sure "Enable Modules (C and Objective-C)" is set to Yes.'
