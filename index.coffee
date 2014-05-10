errors = require 'errors'

# derived from https://gist.github.com/almost/1396231

class Model

  # fields are the class definition's fields
  # attrs are the class instance's properties

  validPropertyArgs = [
    'get'
    'set'
    'default'
    'const'
  ]

  @property = (name, options = {}) ->
    for i of options
      throw new errors.IllegalArgumentError if i not in validPropertyArgs

    # default options
    options.const ?= false

    @fields ?= {}

    fieldProperties = {}
    fieldProperties.default ?= options.default
    @fields[name] = fieldProperties

    # default property options
    propertyOptions = {
      set: options.set
      get: options.get
    }
    propertyOptions.get ?= -> @attr[name]
    if !options.const
      propertyOptions.set ?= (value) -> @attr[name] = value
    else
      propertyOptions.set = (value) -> throw new errors.ConstError

    Object.defineProperty @prototype, name, propertyOptions

  constructor: (attr) ->
    @attr = {}
    # copy in attr passed in or defaults from the fields as appropriate
    for name, options of @constructor.fields
      # defaults can be specified as values or as functions
      @attr[name] = attr?[name] || if (isFunction(options.default)) then options.default() else options.default
    @listeners = {}

  # events
  on: (event, listener) =>
    (@listeners[event] ?= []).push(listener)
    @
  off: (event) =>
    @listeners[event] = []
    @
  emit: (event, args...) =>
    listener(args...) for listener in @listeners[event] if @listeners[event]
    @

  # Setter
  set: (param1, param2) =>
    if typeof param1 is 'object'
      attrs = param1
      for name, value of attrs
        @[name] = value
    else
      name = param1
      value = param2
      @[name] = value
    @

  toJSON: =>
    @attr

# errors

errors.create
  name: 'ConstError'
  defaultMessage: 'This property is constant'
errors.create
  name: 'IllegalArgumentError'
  defaultMessage: 'An invalid argument was passed'

# helper methods

isFunction = (obj) ->
  Object.prototype.toString.call(obj) == '[object Function]'

# exports

module.exports = Model