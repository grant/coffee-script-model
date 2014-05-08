Model = require '../'
should = require 'should'

describe 'model', ->
  it 'should reject undefined fields', ->
    class Empty extends Model
      constructor: ->

    empty = new Empty
    should.not.exist empty.something
  it 'should have simple properties', ->
    class UserSimple extends Model
      @property 'username'

    user = new UserSimple
    user.username.should.be.undefined