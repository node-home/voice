home = require 'home'
core = require './core'

module.exports = home.app module,
  name: 'Voice'
  info: """
    The speech module used for both parsing and producing phrases.
  """
  , (app) ->
    app.grammar = new core.Grammar
