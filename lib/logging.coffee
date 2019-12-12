bunyan = require 'bunyan'
config = require '../config'

module.exports = (name) ->
  bunyan.createLogger
    name: name
    streams: [config.logger]
