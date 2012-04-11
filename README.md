wiqr - A simple qr code generator / URL Shortener written for node.js
===

This is a simple project I cooked up over the weekend to teach myself node.js (and the _express_ framework)

## Features
- No account needed.
- Just put in a URL and a shortened URL with a corresponding QR code is generated.
- Track the number of hits by visiting the shortened URL with a '+' appended.

## Dependencies
- An S3 account + bucket for storing qr code images
- A redis server for data storage

Note: A special version of the node.js canvas package is used for heroku compatibility. If you don't use heroku, you should change it to use the default "canvas" package.

## Issues/TODO
- Generate shorter URLs.
- Keep track of generated URLs so that none get overwritten.
- Support unicode characters
