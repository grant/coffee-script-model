Model = require '../'
should = require 'should'

describe 'model', ->

  # getters and setters

  describe 'getters and setters', ->
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
      should.not.exist(userUndefined.username)

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

  # default values

  describe 'default values', ->
    it 'should have default values', ->
      class User extends Model
        @property 'username',
          default: 'default-username'

      user = new User
      should(user.username).equal 'default-username'

      userDefined = new User username: 'grant'
      should(userDefined.username).equal 'grant'

    it 'should have dynamic default values', ->
      class Program extends Model
        @property 'debug_level',
          default: -> outsideDebugLevel

      outsideDebugLevel = 1

      program1 = new Program debug_level: 4
      should(program1.debug_level).equal 4

      program2 = new Program
      should(program2.debug_level).equal 1

      outsideDebugLevel = 4

      program3 = new Program
      should(program3.debug_level).equal 4

  describe 'writable', ->
    it 'should be writeable when enabled', ->
      class User extends Model
        @property 'username',
          writeable: true

      user = new User
      user.username = 'grant'
      should(user.username).equal 'grant'

    it 'should not be writable when disabled', ->
      class User extends Model
        @property 'username',
          writable: false

      user = new User
      try
        user.username = 'grant'
      catch e
        e.name.should.equal 'NotWritableError'