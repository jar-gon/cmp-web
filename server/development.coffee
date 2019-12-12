express = require 'express'
{extend} = require 'lodash'
config = require '../config'

module.exports = (app) ->
  # pug
  app.set 'view engine', 'pug'
  extend app.locals,
    basedir: process.cwd() + '/views/'
    pages: config.pages
  require './pug'

  # static
  app.use "/#{src}", express.static "node_modules/#{dest}" for src, dest of {
    'js/jquery.js': 'jquery/dist/jquery.js'
  }

  # stylus
  stylus = require 'stylus'
  app.use '/css', stylus.middleware
    src: 'public/css'
    compile: (str, path) ->
      stylus str
        .set 'filename', path
        .set 'include css', true
        .set 'sourcemap', inline: true
        .include process.cwd() + '/node_modules'

  # coffee
  app.use '/js', (req, res, next) ->
    coffee = require('express-coffee-script')
      src: 'public/js'
      compile: require('coffeescript').compile
      compilerOpts:
        filename: 'public/js' + req.path
        inlineMap: true
    coffee req, res, next
