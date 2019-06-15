#!/bin/bash

if ! hash jq 2>/dev/null; then
    echo "This script requires jq.  Do brew install jq."
fi

DEVICE_TYPE=`xcrun simctl list devicetypes "iPhone 8" --json | jq '.devicetypes[0].identifier' --raw-output`
RUNTIME=`xcrun simctl list runtimes "iOS" --json | jq '.runtimes[0].identifier' --raw-output`

LOGO="🧪 "
URL='https://localhost:1443/'
CERT_PATH=`pwd`/test-ca.crt

# Generating cert

echo "${LOGO} Generating self-signed certificate"

openssl req -x509 -newkey rsa:4096 -keyout test-ca.key -out ${CERT_PATH} -days 365 -nodes -subj '/CN=localhost'

# HTTPS server

echo "${LOGO} Starting https server"
./simple_https_server.py &
HTTP_SERVER_PID=$!

# Create simulator

echo "${LOGO} Creating simulator ($DEVICE_TYPE / $RUNTIME)"
UUID=`xcrun simctl create cert-test-iphone ${DEVICE_TYPE} ${RUNTIME}`

if [ $? -eq 0 ]; then
    echo "${LOGO} UUID is ${UUID}"
else
    echo "${LOGO} Error creating simulator. Maybe your selected Xcode isn't 10.2?  That's what I'm expecting."
    exit 1
fi

# Installing 

echo "${LOGO} Installing root certificate"
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
echo "${LOGO} When confirmed, press enter to clean up, deleting this test simulator."
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

