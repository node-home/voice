Speakable = require './record'

console.log "START", Speakable

run = ->
  speakable = new Speakable threshold: 0.05

  speakable.on 'speechStart', ->
    console.log 'onSpeechStart'

  speakable.on 'speechStop', ->
    console.log 'onSpeechStop'

  speakable.on 'speechReady', ->
    console.log 'onSpeechReady'

  speakable.on 'error', (err) ->
    console.log 'onError:'
    console.log err
    do record

  speakable.on 'speechResult', (recognizedWords) ->
    console.log 'onSpeechResult:'
    console.log recognizedWords
    do record

  do record = ->
    console.log "RECORD!"
    do speakable.recordVoice

  console.log "DONE"

module.exports = {run}

do run