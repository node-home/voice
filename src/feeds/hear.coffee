flow  = require 'home.flow'
voice = require '../'

flow.sink 'hear',
  name: 'Hear'
  info: """
    The listening ear of home. The central point
    where all spoken and written commands enter the system.
  """
  params:
    grammar:
      info: """
        An object with a `parse` method that takes a phrase
        and returns an object with intent and optionally arguments.

        Return a function that takes a phrase and an optional source.
      """
, ({grammar}) ->
  ({phrase, source}) ->
    {intent, args} = grammar.parse phrase
    flow.hub.emit 'intent', intent, args if intent

flow.action 'hear',
  name: 'Hear'
  params:
    statement:
      type: 'string'
      required: 'yes'
, ({intent}) ->
  [intent, args...] = grammar.parse
  flow.hub.emit 'intent', intent, args if intent
