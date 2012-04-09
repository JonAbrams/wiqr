# 
# GET home page.
# 

s3_client = require('knox').createClient(
  key: process.env.S3_KEY
  secret: process.env.S3_SECRET
  bucket: 'mintchiptrade'
)

qrcode = require "qrcode"

redis = require "redis"
redis_client = redis.createClient()
redis_client.auth process.env.REDIS_AUTH or ""

exports.index = (req, res) ->
  res.render 'index', title: 'MintChip Trader'

exports.give = {}

exports.give.create = (req, res) ->
  id = Math.floor(Math.random() * 1000000)
  redis_client.set "give-#{id}", req.body.amount
  qrcode.toDataURL "http://localhost/give/#{id}", (err, data) ->
    buf = new Buffer(data.replace(/^data:image\/png;base64,/,""), 'base64')
    s3_req = s3_client.put "give/#{id}.png",
      'Content-Length': buf.length
      'Content-Type': 'text/plain'
    s3_req.on 'response', (s3_res) ->
      if s3_res.statusCode is 200
        res.redirect "/give/#{id}"
      else
        res.end "Epic fail! Couldn't connect to S3 :("
    s3_req.end(buf)

exports.give.show = (req, res) ->
  redis_client.get "give-#{req.params.id}", (err, data) ->
    amount = data.toString()
    if amount
      res.write "<html><body>Amount to give: #{amount} <br>"
      res.end "<img src='//s3.amazonaws.com/mintchiptrade/give/#{req.params.id}.png'/></body></html>"
    else
      res.redirect "/"

exports.give.index = (req, res) ->
  res.end "Here's the list!"