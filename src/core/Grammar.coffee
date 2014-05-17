_ = require 'lodash'

class Grammar
  constructor: (intents) ->
    # The tree structure connects expressions
    # Expressoin are either fixed strings or
    # Variables of a type, to be parsed form the input
    @tree = {}

    # This holds backreferences to all the statement leaves in the tree
    # This is used to forget intents
    @intents = {}

    intents = [intents] unless _.isArray intents

    return

    @learnIntent intent for intent in intents

  learnGrammar: (grammar={}) ->
    _.merge @tree, grammar.tree
    _.merge @intents, grammar.intents

  learnIntent: (intent) ->
    for statement in intent.statements
      for expression in statement.expressions
        for variation in expression.getVariations()
          tree = @tree
          for word in _.compact(variation.split ' ').map String.toLowerCase when word
            tree = tree[word] ?= {}
          tree[''] = intent

  learn: (arg) ->
    if arg instanceof Grammar then @learnGrammar arg else @learnIntent arg

  # Return the intent for given words or null
  match: (words) ->
    return unless _.isString words

    words = words.split ' ' if isString words
    words = _.map words, String.toLowerCase
    current = @callbacks

    while words.length
      word = words[0]
      switch
        when current[word]
          console.log "CASE 1", word, current[word]
          current = current[word]
        when word and current['*']
          # TODO capture words for wildcard
          null
        when current['']
          console.log "CASE 2", word, current['']
          return current[''] words
        else
          console.log "CASE 3", word
          return null
      words.shift()

  # Recursively remove words from the tree, deleting
  # nodes that become empty
  forgetStatement = (words, node) ->
    return unless words?
    first = node? && words
    node ?= @tree

    words = words.split ' ' if _.isString words
    words = _.compact(words).map String.toLowerCase
    words = words.shift()

    intent = forgetNode node[word], words if node[word]?
    if intent?
      delete node[word]
      delete @intents[intent] unless _.pull(@intents[intent], statement).length

    switch _.keys node
      when ['']
        return @intents[node['']]
      when []
        return true
      else
        return false

  # Remove all statements of an intent from the tree
  forgetIntent = (intent) ->
    @forgetStatement statement for statement in @intents[intent] || []

  # Remove as intent if it exists as such, else as statement
  forget = (str) ->
    return unless str
    str = [str] if _.isString str
    if @intents[s] then @forgetIntent s else @forgetStatement s for s in str

module.exports = Grammar