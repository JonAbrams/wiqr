# 
# GET home page.
# 

s3_client = require('knox').createClient(
  key: process.env.S3_KEY
  secret: process.env.S3_SECRET
  bucket: 'mintchiptrade'
)

redis = require("redis")
redis_client = redis.createClient()

exports.index = (req, res) ->
  res.render 'index', title: 'MintChip Trader'

exports.give = {}

exports.give.create = (req, res) ->
  # res.end "Look: #{req.body.amount}"
  buf = "#{req.body.amount}"
  id = Math.floor(Math.random() * 1000000)
  s3_req = s3_client.put "give/#{id}",
    'Content-Length': buf.length
    'Content-Type': 'text/plain'
  s3_req.on 'response', (s3_res) ->
    if s3_res.statusCode is 200
      redis_client.set "give-#{id}", "#{req.body.amount}"
      res.redirect "/give/#{id}"
    else
      res.end "Epic fail! Couldn't connect to S3 :("
  s3_req.end(buf)

exports.give.show = (req, res) ->
  s3_client.get("give/#{req.params.id}").on 'response', (s3_res) ->
    s3_res.setEncoding('utf8')
    s3_res.on 'data', (chunk) ->
      res.end "You want to give #{chunk}!"
  .end()

exports.give.index = (req, res) ->
  res.end "Here's the list!"