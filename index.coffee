isFunction = (obj) ->
  Object.prototype.toString.call(obj) == '[object Function]'

# Derived from https://gist.github.com/almost/1396231

class Model

  # Fields are the class definition's fields
  # Attrs are the class instance's properties

  @property = (name, options = {}) ->
    @fields ?= {}

    fieldProperties = {}
    fieldProperties.default ?= options.default
    @fields[name] = fieldProperties

    # Default getter and setter
    options.get ?= -> @attr[name]
    options.set ?= (value) -> @attr[name] = value

    Object.defineProperty @prototype, name, options

  constructor: (attr) ->
    @attr = {}
    # Copy in attr passed in or defaults from the fields as appropriate
    for name, options of @constructor.fields
      # Defaults can be specified as values or as functions
      @attr[name] = attr?[name] || if (isFunction(options.default)) then options.default() else options.default
    @listeners = {}

  # Events
  bind: (event, listener) =>
    (@listeners[event] ?= []).push(listener)
  unbind: (event) =>
    remove @listener[event]
  emit: (event, args...) =>
    listener(args...) for listener in @listeners[event] if @listeners[event]

module.exports = Model