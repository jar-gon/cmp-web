path = require 'path'
express = require 'express'
logger = require('./lib/logging') 'app'
config = require './config'

app = express()
app.set 'views', 'views'
app.set 'trust proxy', config['trust proxy']

app.use require('morgan') config.logging.morgan if config.logging.morgan

require('./server/development') app

app.use '/', require './server/routes'
app.use express.static 'public',
  maxage: config.maxage

app.use (req, res, next) ->
  res.status 404
  res.redirect '/404.html'

app.use (err, req, res, next) ->
  err.status = err.status or 500
  res.status err.status
  res.render 'error',
    error: err
    message: unless config['display error'] and err.message then 'Internal Server Error' else err.message
  logger.error err if err.status == 500

server = require('http').createServer app
server.listen config.port, config.host
server.on 'listening', ->
  logger.info
    host: config.host
    port: config.port
    node_env: process.env.NODE_ENV
    log: config.logger.level
