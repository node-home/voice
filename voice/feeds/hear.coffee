home = require 'home'

home.sink 'hear',
  name: 'Hear'
  info: """
    The listening ear of home. The central point
    where all spoken and written commands enter the system.
  """
  params:
    grammar:
      info: """
        An object with a `parse` method that takes a phrase.

        Return a function that takes a phrase and an optional source.
      """
  , ({grammar}) ->
    ({phrase, source}) ->
      grammar.parse phrase