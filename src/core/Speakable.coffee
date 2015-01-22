events = require 'events'
util   = require 'util'
spawn  = require('child_process').spawn
http   = require 'http'

class Speakable extends events.EventEmitter
  constructor: (options) ->
    super()

    options ?= {}

    @rate = options.rate ? 16000
    @threshold = options.threshold ? 0.1

    @recBuffer = []
    @recRunning = false
    @apiResult = {}
    @apiLang = options.lang ? "en-US"
    @cmd = __dirname + '/Speakable.sox'
    @cmdArgs = [
      '-b', '16',
      '-d', '-t', 'flac', '-',
      'rate', @rate, 'channels', '1',
      'silence', '1', '0.1', "#{@threshold}%", '1', '1.0', "#{@threshold}%"
    ]

module.exports = Speakable

Speakable.prototype.postVoiceData = ->
  options =
    hostname: 'www.google.com'
    path: "/speech-api/v2/recognize?xjerr=1&client=chromium&pfilter=0&maxresults=1&lang=#{@apiLang}"
    method: 'POST'
    headers:
      'Content-type': "audio/x-flac; rate=#{@rate}"

  req = http.request options, (res) =>
    @recBuffer = []
    return @emit 'error', "Non-200 answer from Google Speech API (#{res.statusCode})" unless res.statusCode == 200

    res.setEncoding 'utf8'
    res.on 'data', (chunk) ->
      @apiResult = JSON.parse chunk
    res.on 'end', ->
      do @parseResult

  req.on 'error', (e) ->
    @emit 'error', e

  # write data to request body
  console.log 'Posting voice data...'
  for prop in @recBuffer
    req.write new Buffer @recBuffer[prop], 'binary' if @recBuffer.hasOwnProperty prop
  do req.end

Speakable.prototype.recordVoice = ->
  rec = spawn @cmd, @cmdArgs, 'pipe'

  rec.stdout.on 'readable', =>
    @emit 'speechReady'

  rec.stdout.setEncoding 'binary'
  rec.stdout.on 'data', (data) =>
    unless @recRunning
      @emit 'speechStart'
      @recRunning = true
    @recBuffer.push data

  # Process stdin
  rec.stderr.setEncoding 'utf8'
  rec.stderr.on 'data', (data) =>
    console.log data

  rec.on 'close', (code) =>
    @recRunning = false
    @emit 'error', "sox exited with code #{code}" if code
    @emit 'speechStop'
    do @postVoiceData

Speakable.prototype.resetVoice = ->
  @recBuffer = []

Speakable.prototype.parseResult = ->
  recognizedWords = if @apiResult.hypotheses?[0] then @apiResult.hypotheses[0].utterance.split ' ' else []

  @emit 'speechResult', recognizedWords
