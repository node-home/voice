https = require 'https'
Q     = require 'q'

ACCESS_TOKEN = process.env.WIT_ACCESS_TOKEN
VERSION      = process.env.WIT_VERSION ? '20140620'

request = (text) ->
  dfd = Q.defer()

  options =
    host: 'api.wit.ai'
    path: '/message?q=' + encodeURIComponent text
    # the Authorization header allows you to access your Wit.AI account
    # make sure to replace it with your own
    # the Accept header allows to request a specific version of the API
    #  make sure to replace the YYYYMMDD with the version date you wanted
    headers:
      'Authorization': 'Bearer ' + ACCESS_TOKEN
      'Accept': 'application/vnd.wit.' + VERSION

  https.request options, (res) ->
    response = ''

    res.on 'data', (chunk) ->
      response += chunk

    res.on 'end', ->
      dfd.resolve JSON.parse response

  .on 'error', (e) ->
      dfd.reject e
  .end()

  dfd.promise

parse = (text, confidence=0) ->
  request(text).then (response) ->
    outcome = response.outcomes[0]
    throw new Error "Not convinced" if outcome.confidence < confidence
    outcome

module.exports = {request, parse}