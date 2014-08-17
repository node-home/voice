home = require 'home'
home.init()

console.log "LOADED DONE"

{expression, statement, grammar} = require '../src/extensions'

describe 'language', ->
  describe 'expression', ->
    it 'should validate arguments'

    it 'should match strings', ->
      expr = expression 'all good'
      expr.match('all good').should.be.true
      expr.match('ALL GOOD').should.be.true
      expr.match('all bad').should.be.false
      expr.match('all').should.be.false
      expr.match('').should.be.false

    it 'should support variations', ->
      expr = expression [
        'one way'
        'or another'
      ]
      expr.match('one way').should.be.true
      expr.match('OR ANOTHER').should.be.true
      expr.match('one another').should.be.false
      expr.match('or').should.be.false
      expr.match('').should.be.false

    it 'should support wildcards', ->
      expr = expression '*'
      expr.match('anything').should.be.true
      expr.match('!@#$%').should.be.true
      expr.match('').should.be.false

    it 'should capture matches'

    it 'should combine a series of expressions', ->
      part = expression ['options', 'choices']

      expr = expression [
        'one of'
        ['many', 'a dozen']
        part
      ]

      expr.match('one of many options').should.be.true
      expr.match('one of a dozen choices').should.be.true
      expr.match('one of many dozen options').should.be.false
      expr.match('one of many').should.be.false
      expr.match('').should.be.false

    it 'should support variations', ->
      expr = expression [
        'one', ['way', 'road']
      ], [
        'or another'
      ]

      expr.match('one way').should.be.true
      expr.match('one road').should.be.true
      expr.match('or another').should.be.true
      expr.match('one another').should.be.false
      expr.match('one').should.be.false

    it 'should prevent circular references'

  describe 'statement', ->
    it 'should match strings'
    it 'should reference an intent'

  describe 'intent', ->
    it 'should be fired as an event'
    it 'should be discoverable'
    it 'should accept statements'
    it 'should accept arrays of strings'

  describe 'grammar', ->
    it 'should accept intents', ->
      G = grammar(
        intent 'turn lights on', [
          "it's dark in here"
          "turn the lights on"
        ]
      )
      G.match("it's dark in here").should.eql 'turn the lights on'
      G.match("Could you turn the lights on").should.eql 'turn the lights on'

    it 'should accept objects with strings', ->
      G = grammar
        'order pizza': [
          "I'm hungry"
          "pizza"
        ]
      G.match("I'm hungry").should.eql 'pizza'
      G.match("I really feel like eating pizza").should.eql 'pizza'
      (null == G.match("I'm thirsty")).should.be.true

    it 'should add statements', ->
      G.learn 'play music': ["dj take it away"]
      G.match('dj take it away').should.eql 'play music'
      (null == G.match('dj keep it here')).should.be.true

    it 'should update statements', ->
      G.learn 'play music': ["music please"]
      G.match('dj take it away').should.eql 'play music'
      G.match('dj take it away').should.eql 'play music'
      (null == G.match('dj keep it here')).should.be.true

    it 'should remove statements', ->
      G.forget 'play music'
      (null == G.match('dj take it away')).should.be.true

      G.forget 'order pizza': ["I'm hungry"]
      G.match('pizza').should.eql 'pizza'
      (null == G.match("I'm hungry")).should.be.true

    it 'should give precedence to non-wildcards'
    it 'should consider all paths with wildcards before failing'
    it 'should dispatch intents'

  describe 'captures', ->
    it 'should support numbers'
    it 'should support dates'
    it 'should support times'
    it 'should support datetimes'
    it 'should support options'
    it 'should support booleans'
