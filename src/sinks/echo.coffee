flow = require 'home.flow'

voice = require '../'

module.exports = flow.sink 'echo',
  info: """
    This sink says aloud all events from its feed.
  """
, ->
  (trigger, args={}) ->
    console.log "ECHO", trigger, args
    voice.voice.say trigger
    voice.voice.say "#{key} #{val}" for key, val of args