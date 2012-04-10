# Setup services
s3_client = require("knox").createClient(
  key: process.env.S3_KEY
  secret: process.env.S3_SECRET
  bucket: "wiqr"
)

qrcode = require "qrcode"

redis = require "redis"
redis_client = redis.createClient process.env.REDIS_PORT or null, process.env.REDIS_HOST or null
redis_client.auth process.env.REDIS_AUTH or ""

# Handlers

exports.index = (req, res) ->
  res.render 'index', {}
  res.end()

exports.entry = {}

exports.entry.create = (req, res) ->
  id = Math.floor(Math.random() * 1000000)
  redis_client.hmset "#{id}-text", {text: req.body.url, count: 0 }
  shrunken_url = "http://#{req.headers.host}/#{id}"
  qrcode.toDataURL shrunken_url, (err, data) ->
    buf = new Buffer(data.replace(/^data:image\/png;base64,/,""), 'base64')
    s3_req = s3_client.put "qrcodes/#{id}.png",
      "Content-Length": buf.length
      "Content-Type": "image/png"
    s3_req.on 'response', (s3_res) ->
      if s3_res.statusCode is 200
        res.redirect "#{shrunken_url}+"
      else
        res.end "Epic fail! Couldn't connect to S3, sorry :("
    s3_req.end(buf)

exports.entry.show = (req, res, next) ->
  if not req.params.id? or req.params.id is "favicon.ico"
    next()
  else
    id = req.params.id
    plus = id[id.length-1] is '+'
    if plus
      id = id.substring 0, id.length - 1
    redis_client.hgetall "#{id}-text", (err, obj) ->
      text = obj.text.toString() if obj? and obj.text?
      if text?
        if plus
          redis_client.hincrby "#{id}-text", "count", 1
          res.render "entry"
            , short_url: "http://#{req.headers.host}/#{id}"
            , qr_url: "//s3.amazonaws.com/wiqr/qrcodes/#{id}.png"
            , text: text
            , count: obj.count
            , type: "url" # TODO: Support different types of qr codes
        else
          res.redirect text
      else
        res.redirect "/"
