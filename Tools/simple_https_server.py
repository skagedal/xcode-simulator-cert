#!/usr/bin/env python3

from http.server import HTTPServer,SimpleHTTPRequestHandler
from socketserver import BaseServer
import ssl

httpd = HTTPServer(('0.0.0.0', 1443), SimpleHTTPRequestHandler)
httpd.socket = ssl.wrap_socket (httpd.socket, certfile='test-ca.crt', keyfile='test-ca.key', server_side=True)
httpd.serve_forever()
