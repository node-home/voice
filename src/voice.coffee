events = require 'events'

home = require 'home'
core = require './core'

module.exports = home.app module,
  name: 'Voice'
  info: """
    The speech module used for both parsing and producing phrases.
  """
  , (app) ->
    app.feeds = require './feeds'
    app.models = require './models'

    app.bus = bus = new events.EventEmitter
    app.grammar = new core.Grammar
    app.voice = new core.Voice
    app.speakable = speakable = new core.Speakable threshold: 0.05

    speakable.on 'speechStart', ->
      bus.emit 'onSpeechStart'
      console.log 'onSpeechStart'

    speakable.on 'speechStop', ->
      bus.emit 'onSpeechStop'
      console.log 'onSpeechStop'

    speakable.on 'speechReady', ->
      bus.emit 'onSpeechReady'
      console.log 'onSpeechReady'

    speakable.on 'error', (err) ->
      bus.emit 'onError', err
      console.log 'onError:'
      console.log err
      do record

    speakable.on 'speechResult', (recognizedWords) ->
      bus.emit 'onError', recognizedWords
      console.log 'onSpeechResult:'
      console.log recognizedWords
      do record

    return "voice.src.voice no record"

    do record = ->
      console.log "RECORD!"
      do speakable.recordVoice

