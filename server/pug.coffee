path = require 'path'
pug = require 'pug'
{extend} = require 'lodash'

getFilename = (filename, replace) ->
  filename = path.relative process.cwd() + '/views', filename
  unless replace then filename else filename.replace /\//g, '-'

extend pug.filters,
  coffee: require('pug-coffee') (coffeeOptions, {filename}) ->
    coffeeOptions.filename = 'public/js/' + getFilename filename, true