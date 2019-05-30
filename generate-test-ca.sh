#!/bin/bash

# This can be useful for testing the install-ca command

openssl genrsa -out test-ca.key 4096
openssl req -x509 -new -nodes -key test-ca.key -sha256 -days 1024 -out test-ca.crt

