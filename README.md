wiqr - A simple qr code generator / URL Shortener written for node.js
===

This is a simple project I cooked up over the weekend to teach myself node.js (and the _express_ framework)

## Features
- No account needed.
- Just put in a URL and a shortened URL with a corresponding QR code is generated.
- Track the number of hits by visiting the shortened URL with a '+' appended.

## Dependencies
- A redis server for data storage

Note: A special version of the node.js canvas package is used for heroku compatibility. If you don't use heroku, you should change it to use the default *canvas* package.

## Issues/TODO
- Support unicode characters in URLs.

## Author
**Jon Abrams**

- [Follow on Twitter](http://twitter.com/JonathanAbrams)

## License

(The MIT License)

Copyright (c) 2012 Jon Abrams

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
