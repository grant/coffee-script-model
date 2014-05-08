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

  it 'should have getters', ->
    class Dog extends Model
      @property 'sound',
        get: -> 'woof'

    dog1 = new Dog
    should(dog1.sound).equal 'woof'

    dog2 = new Dog sound: 'bowwow'
    should(dog2.sound).equal 'woof'

  it 'should have setters', ->
    class EvilNumber extends Model
      @property 'value',
        set: (newValue) -> @attr['value'] = newValue + 2

    num = new EvilNumber value: 0
    num.value = 1
    should(num.value).equal 3