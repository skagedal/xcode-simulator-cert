#!/bin/bash

# This can be useful for testing the install command

openssl req -x509 -newkey rsa:4096 -keyout test-ca.key -out test-ca.crt -days 365 -nodes -subj '/CN=localhost'
