#!/bin/bash

LOGO="🧪 "
DEVICE_TYPE=com.apple.CoreSimulator.SimDeviceType.iPhone-7
RUNTIME=com.apple.CoreSimulator.SimRuntime.iOS-12-2
URL='https://localhost:1443/'

# HTTPS server

echo "${LOGO} Starting https server"
./simple_https_server.py &
HTTP_SERVER_PID=$!

# Create simulator

echo "${LOGO} Creating simulator"
UUID=`xcrun simctl create cert-test-iphone ${DEVICE_TYPE} ${RUNTIME}`

if [ $? -eq 0 ]; then
    echo "${LOGO} UUID is ${UUID}"
else
    echo "${LOGO} Error creating simulator. Maybe your selected Xcode isn't 10.2?  That's what I'm expecting."
    exit 1
fi

# Installing 

echo "${LOGO} Installing root certificate"
CERT_PATH=`pwd`/test-ca.crt
pushd .. >& /dev/null
echo swift run xcode-simulator-tool --verbosity=loud install-ca ${CERT_PATH} --uuid=${UUID}
swift run xcode-simulator-tool --verbosity=loud install-ca ${CERT_PATH} --uuid=${UUID}
popd >& /dev/null

# Booting

echo "${LOGO} Booting simulator; press enter when done"
xcrun simctl boot ${UUID}
open /Applications/Xcode-10.2.1.app/Contents/Developer/Applications/Simulator.app
read

# Opening the URL

echo "${LOGO} Opening ${URL} in simulator.  This should now show the contents of this directory in Safari."
echo "${LOGO} Press enter when done."
xcrun simctl openurl ${UUID} ${URL}
read

# Killing HTTP server

echo "${LOGO} Killing http server $HTTP_SERVER_PID"
kill $HTTP_SERVER_PID

# Delete simulator

echo "${LOGO} Deleting simulator"
xcrun simctl delete ${UUID}
if [ $? -ne 0 ]; then
    echo "${LOGO} Could not delete simulator with uuid ${UUID} for some reason."
    exit 1
fi

