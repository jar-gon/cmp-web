{zipObject} = require 'lodash'

module.exports =
  object: (array, keys) ->
    if typeof keys == 'function'
      keys = array.map (x) -> keys x, array
    zipObject keys, array
