# Setup services

qrcode = require "qrcode"

redis = require "redis"
redis_client = redis.createClient process.env.REDIS_PORT or null, process.env.REDIS_HOST or null
redis_client.auth process.env.REDIS_AUTH or ""

shorty = require('node-shorty')

# Handlers

exports.index = (req, res) ->
  res.render 'index', {}
  res.end()

exports.entry = {}

exports.entry.create = (req, res) ->
  url = req.body.url
  if url
    redis_client.incr "slug_count", (err, slug_count) ->
      id = slug_count
      slug = shorty.url_encode slug_count
      short_url = "http://#{req.headers.host}/#{slug}"
      redis_client.hmset "#{id}-text", {text: url, slug: slug, count: 0 }, (err, redis_result) ->
          res.redirect "#{short_url}+"
  else
    res.redirect "/"

exports.entry.show = (req, res, next) ->
  if not req.params.slug? or req.params.slug is "favicon.ico"
    next()
  else
    slug = req.params.slug
    plus = slug[slug.length-1] is '+'
    if plus
      slug = slug.substring 0, slug.length - 1
    id = shorty.url_decode slug
    redis_client.hgetall "#{id}-text", (err, obj) ->
      text = obj.text.toString() if obj? and obj.text?
      if text?
        if plus
          regex = new RegExp "^(http|https|ftp)\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&amp;%\$\#\=~])*$"
          type = if regex.test(text) then "url" else "text"
          short_url = "http://#{req.headers.host}/#{slug}"
          qrcode.toDataURL short_url, (err, data) ->
            res.render "entry"
              short_url: short_url
              text: text
              count: obj.count
              type: type
              qr_code: data
        else
          redis_client.hincrby "#{id}-text", "count", 1
          res.redirect text
      else
        res.redirect "/"
