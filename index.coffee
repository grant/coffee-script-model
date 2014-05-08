errors = require 'errors'

# derived from https://gist.github.com/almost/1396231

class Model

  # fields are the class definition's fields
  # attrs are the class instance's properties

  @property = (name, options = {}) ->
    # default options
    options.writable ?= true

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
    if options.writable
      propertyOptions.set ?= (value) -> @attr[name] = value
    else
      propertyOptions.set = (value) -> throw new errors.NotWritableError

    Object.defineProperty @prototype, name, propertyOptions

  constructor: (attr) ->
    @attr = {}
    # copy in attr passed in or defaults from the fields as appropriate
    for name, options of @constructor.fields
      # defaults can be specified as values or as functions
      @attr[name] = attr?[name] || if (isFunction(options.default)) then options.default() else options.default
    @listeners = {}

  # events
  bind: (event, listener) =>
    (@listeners[event] ?= []).push(listener)
  unbind: (event) =>
    remove @listener[event]
  emit: (event, args...) =>
    listener(args...) for listener in @listeners[event] if @listeners[event]

# errors

errors.create
  name: 'NotWritableError'
  defaultMessage: 'This property is not writable'

# helper methods

isFunction = (obj) ->
  Object.prototype.toString.call(obj) == '[object Function]'

# exports

module.exports = Model