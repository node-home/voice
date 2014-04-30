voice = require '../voice'

voice.interface 'Thing',
  info: """
    The interface of a matchable piece of text
  """
  ,
  match: (words) ->

###
 * A meaningful string of words.
###
voice.model 'Expression',
  schema:
    name:
      type: String
      required: yes
    context:
      type: 'voice.Expression'
      info: """
        This is like a namespace for expressions
      """
    continuations:
      type: ['voice.Expression']
      info: """
        The continuations of this expression.
      """

###
 * A complete combination of expressions to
###
voice.model 'Phrase',
  schema:
    name:
      type: String
      required: yes
    expression:
      type: 'voice.Expression'

    variations:
      type: [String]

