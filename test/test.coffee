Model = require '../'
should = require 'should'

errors = require 'errors'
errors.create
  name: 'ImmutableError'

describe 'model', ->

  # getters and setters

  describe 'getters and setters', ->
    it 'should reject undefined fields', ->
      class Empty extends Model

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

  describe 'const', ->
    it 'should not be const when disabled', ->
      class User extends Model
        @property 'username',
          const: false

      user = new User
      user.username = 'grant'
      should(user.username).equal 'grant'

    it 'should be const when enable', ->
      class User extends Model
        @property 'username',
          const: true

      user = new User
      try
        user.username = 'grant'
      catch e
        errorThrown = true
        e.name.should.equal 'ConstError'
      if !errorThrown
        throw new Error 'No ConstError was thrown'

  describe 'bad options argument', ->
    it 'should throw an illegal argument error', ->
      try
        class User extends Model
          @property 'username',
            badProperty: true
      catch e
        errorThrown = true
        e.name.should.equal 'IllegalArgumentError'
      if !errorThrown
        throw new Error 'No IllegalArgumentError was thrown'

  describe 'events', ->
    it 'should emit properly', ->
      class User extends Model
        @property 'username',
          set: (newUsername) ->
            if newUsername != @username
              @attr.username = newUsername
              @emit('changed username', newUsername)

      user = new User username: 'grant'
      changed = false
      user.on 'changed username', (username) ->
        changed = true
        username.should.equal 'henry'

      user.username = 'henry'
      if !changed
        throw new Error 'No listen event was created'

    it 'should off properly', ->
      class User extends Model
        @property 'username',
          set: (newUsername) ->
            if newUsername != @username
              @attr.username = newUsername
              @emit('changed username', newUsername)

      user = new User username: 'grant'
      changed = false
      user.on 'changed username', (username) ->
        changed = true
        username.should.equal 'henry'

      user.off 'changed username'

      user.username = 'henry'
      if changed
        throw new Error 'Listen event was created'

  describe 'setter', ->
    it 'should set one attribute', ->
      class User extends Model
        @property 'username'
        @property 'email'

      user = new User
      user.set 'username', 'grant'
      user.username.should.equal 'grant'

    it 'should set multiple attributes', ->
      class User extends Model
        @property 'username'
        @property 'email'

      user = new User
      user.set
        username: 'grant'
        email: 'email@example.com'
      user.username.should.equal 'grant'
      user.email.should.equal 'email@example.com'

    it 'should give an error for bad set', ->
      class User extends Model
        @property 'username',
          set: () -> throw new errors.ImmutableError "Don't set this"
        @property 'email'

      user = new User
      try
        user.set 'username', 'test'
      catch e
        error = true
        e.name.should.equal 'ImmutableError'
      if !error
        throw new Error 'No listen event was created'