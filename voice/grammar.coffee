isString = (s) -> typeof s == 'string' or s instanceof String

class @Grammar
  ###
  Build a tree of word variations that lead up to callbacks

  ###
  constructor: ->
    @callbacks = {}

  teachWords: (variations, callback) ->
    # Activators can be a string of words or an array of those.
    activators = [activators] if isString variations

    for variation in variations
      current = @callbacks
      for word in variation.split ' '
        current = current[word] ?= {}
      current[''] = callback

  parseWords: (words) ->
    words = words.split ' ' if isString words

    current = @callbacks
    while words.length
      word = words[0]
      switch
        when current[word]
          console.log "CASE 1", word, current[word]
          current = current[word]
        when word and current['*']
        when current['']
          console.log "CASE 2", word, current['']
          return current[''] words
        else
          console.log "CASE 3", word
          return
      words.shift()

  forgetWords: (words) ->
    #TODO
    undefined


class @Speech
  defaults:
    continuous: true
    interimResults: true
    lang: 'en-us'

  constructor: (options) ->
    # Use extend from somewhere
    options ||= {}

    for key, val of @defaults
      options[key] = val unless key in options

    unless window.webkitSpeechRecognition
      upgrade()
    else
      @recognition = new webkitSpeechRecognition

      @recognition.continuous = options.continuous
      @recognition.interimResults = options.interimResults
      @recognition.lang = options.lang

      @recognition.onresult = (event) => @onresult event
      @recognition.onerror = (event) => @onerror event

      @grammar = new Grammar

  interim: (transcript) ->
    console.log "INTERIM", transcript

  dispatch: (transcript) ->
    words = transcript.split ' '

    console.log "FINAL", transcript, "WORDS", words

    words = (word.trim().toLowerCase() for word in words)

    @grammar.perform words

  onerror: (event) ->
    console.log "VOICE ERROR", event

  onresult: (event) ->
    interim_transcript = ''

    for i in [event.resultIndex...event.results.length]
      result = event.results[i]
      if result.isFinal
        @dispatch result[0].transcript.trim()
      else
        interim_transcript += result[0].transcript
        @interim interim_transcript

  start: (callback) ->
    # usually undefined
    @recognition.onend = callback or (event) =>
      console.log "Speech.onend", event
      @start event
    @recognition.start()

  stop: (callback) ->
    # usually undefined
    @recognition.onend = callback
    @recognition.stop()

  on: (activators, callback) ->
    @grammar.teach activators, callback
    # Activators can be a string of words or an array of those.
    if isString activators
      activators = [activators]

    # Add the activator to the callbacks object
    @grammar.teach words, callback for words in activators
