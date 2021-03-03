#!/usr/bin/env python3

from http.server import BaseHTTPRequestHandler, HTTPServer

class Server(BaseHTTPRequestHandler):
  pass

if __name__ == '__main__':
  PORT = 8000
  httpd = HTTPServer(('', PORT), Server)

  print(f"starting server on {PORT}")
  try:
      httpd.serve_forever()
  except KeyboardInterrupt:
      pass
  httpd.server_close()
