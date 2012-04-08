# 
# GET home page.
# 

s3_client = require('knox').createClient(
  key: process.env.S3_KEY
  secret: process.env.S3_SECRET
  bucket: 'mintchiptrade'
)

exports.index = (req, res) ->
  res.render 'index', title: 'MintChip Trader'

exports.give = (req, res) ->
  # res.end "Look: #{req.body.amount}"
  buf = "Amount deposited: #{req.body.amount}"
  s3_req = s3_client.put "give/#{Math.floor(Math.random() * 1000000)}",
    'Content-Length': buf.length
    'Content-Type': 'text/plain'
  s3_req.on 'response', (s3_res) ->
    if s3_res.statusCode is 200
      res.end "Successfully wrote to s3!!"
    else
      res.end "Epic fail!"
  s3_req.end(buf)
