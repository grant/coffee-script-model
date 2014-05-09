Model = require './'

# getters and setters example

class Person extends Model
  @property 'firstName'
  @property 'lastName'
  @property 'fullName',
    get: -> "#{@firstName} #{@lastName}"
    set: (name) -> [@firstName, @lastName] = name.split ' '
  @property 'username'
  @property 'sick', default: false

person = new Person firstName: 'bob', lastName: 'smith'
console.log person.fullName

person.fullName = 'thomas vi'
console.log person.firstName

# events example

class User extends Model
  @property 'username',
    set: (newUsername) ->
      if newUsername != @username
        @attr.username = newUsername
        @emit('changed username', newUsername)
  @property 'twitter'
  @property 'created_at',
    default: -> new Date()
    get: ->
      MM = @attr.created_at.getMonth() + 1
      dd = @attr.created_at.getDate()
      yyyy = @attr.created_at.getFullYear()
      "#{MM}/#{dd}/#{yyyy}"

user = new User(
  username: 'grant'
  twitter: 'granttimmerman'
)

# bind to the change event for the title property
user.bind 'changed username', (value) =>
  console.log "Username updated to #{value}"

# change the user's username (which will trigger the event bound above)
user.username = 'thomas'

console.log "Created date: #{user.created_at}"