voice = require '../voice'

Word = require './word'

###
 * A normalized variation on a piece of text.
###
voice.model 'Variation',
  schema:
    text: String
    original: -> @belongsTo Word
