say = require 'say'

class Voice
  constructor: (@name='Victoria') ->

  say: (text, callback) ->
    say.speak @name, text, callback

module.exports = Voice
