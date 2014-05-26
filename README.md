coffee-script-model
===================

A simple wrapper over the coffee-script class with getters, setters, fields, and event bindings

```bash
npm install coffee-script-model --save
```

### Example

```coffee
require 'coffee-script-model'

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
# 'bob smith'

person.fullName = 'thomas vi'
console.log person.firstName
# 'thomas'
```

See [example.coffee](example.coffee) for more examples.

### Supports
  - Node
  - Modern browsers
  - IE 9+
