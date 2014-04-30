{expression, statement} = require '../../src/extensions'

describe 'language', ->
  describe 'expression', ->
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

    it 'should combine a series of expressions'
      part = expression ['options', 'choice']

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

    it 'should support variations'
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

  describe 'grammar', ->
    it 'should construct a tree of expressions'
    it 'should have statements for leaves'
    it 'should add statements'
    it 'should remove statements'
    it 'should match strings'
    it 'should give precedence to non-wildcards'
    it 'should consider all paths with wildcards before failing'
    it 'should dispatch intents'
