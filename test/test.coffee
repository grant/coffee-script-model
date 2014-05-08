Model = require '../'
should = require 'should'

describe 'model', ->
  it 'should reject undefined fields', ->
    class Empty extends Model
      constructor: ->

    empty = new Empty
    should.not.exist empty.something

  it 'should have simple properties', ->
    class User extends Model
      @property 'username'

    user = new User username: 'grant'
    should(user.username).equal 'grant'

    userUndefined = new User
    should(user.username).be.undefined

  it 'should have default values', ->
    class User extends Model
      @property 'username',
        default: 'default-username'

    user = new User
    should(user.username).equal 'default-username'

    userDefined = new User username: 'grant'
    should(userDefined.username).equal 'grant'