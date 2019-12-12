express = require 'express'
config = require '../config'

module.exports = router = express.Router()

router.get "/", (req, res) ->
  res.render 'index'

config.routers.forEach (x) ->
  router.get "/#{x}.html", (req, res) ->
    res.render x

router.get '/404', (req, res) ->
  res.status 404
  res.render '404'
