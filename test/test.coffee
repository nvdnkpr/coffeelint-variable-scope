fs = require 'fs'
assert = require('chai').assert
sinon = require 'sinon'
CoffeeScript = require 'coffee-script'
Rule = require '../index.coffee'

getFixtureAST = (fixture) ->
    source = fs.readFileSync("#{__dirname}/fixture/#{fixture}.coffee").toString()
    CoffeeScript.nodes source

suite 'lintNode().', ->
    setup ->
        @rule = new Rule()
        @getFixtureErrors = (fixture) =>
            @rule.lintNode getFixtureAST(fixture)

    suite 'Basic example.', ->
        setup -> @errors = @getFixtureErrors 'basic'

        test 'There are three errors', ->
            assert.equal @errors.length, 3

        test 'First error is between first and fifth line', ->
            assert.equal @errors[0].upper.locationData.first_line, 0
            assert.equal @errors[0].lower.locationData.first_line, 4

        test 'Second error is between second and eleventh line', ->
            assert.equal @errors[1].upper.locationData.first_line, 1
            assert.equal @errors[1].lower.locationData.first_line, 10

        test 'First error is on variable"a"', ->
            assert.equal @errors[0].variable, 'a'

        test 'Scope level diff of second error is 2', ->
            assert.equal @errors[1].lower.scope_level - @errors[1].upper.scope_level, 2

        test 'Scope levels for third error are correct', ->
            assert.equal @errors[2].upper.scope_level, 2
            assert.equal @errors[2].lower.scope_level, 4

    suite 'Object literal.', ->
        setup -> @errors = @getFixtureErrors 'objectLiteral'

        test 'There is only one error', ->
            assert.equal @errors.length, 1

    suite 'Object property.', ->
        setup -> @errors = @getFixtureErrors 'objectProperty'

        test 'There is only one error', ->
            assert.equal @errors.length, 1

    suite 'Last upper and first lower.', ->
        setup -> @errors = @getFixtureErrors 'lastUpperFirstLower'

        test 'Shows correctly', ->
            assert.equal @errors[0].upper.locationData.first_line, 1
            assert.equal @errors[0].lower.locationData.first_line, 4

    suite 'Filter.', ->
        setup -> 
            ast = getFixtureAST 'level'
            @rule.lintNode ast, {}, (lower, upper) ->
                lower.scope_level - upper.scope_level >= 2

        test 'Applies value from config', ->
            assert.equal @errors.length, 1
            
suite 'lintAST().', ->
    setup: ->
        @rule = new Rule()
        
    suite 'Scope diff config option.', ->
        setup ->
            @ast = getFixtureAST 'level'
            @astApi = 
                createError: ->
                config:
                    'variable_scope':
                        scopeDiff: 2 
            sinon.stub @rule, 'scopeDiffFilter'
            @rule.errors = []
            @rule.lintAST @ast, @astApi

        teardown ->
            @rule.scopeDiffFilter.restore()

        test 'Generates filter using config variable', ->
            assert.equal @rule.scopeDiffFilter.getCall(0).args[0], 2