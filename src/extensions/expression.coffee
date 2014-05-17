voice = require '../voice'

{Expression} = require '../models'

module.exports = voice.extension 'expression',
  params:
    parts:
      info: "Array of strings and arrays"
      type: 'array'
  , (args) ->
    new Expression args.parts
