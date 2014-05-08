isFunction = (obj) ->
  Object.prototype.toString.call(obj) == '[object Function]'

# Derived from https://gist.github.com/almost/1396231
class Model
  @property = (name, options = {}) ->
    @fields ?= {}
    fieldProperties = {}
    fieldProperties.default ?= options.default
    @fields[name] = fieldProperties

    options.get ?= -> @attributes[name]
    options.set ?= (value) -> @attributes[name] = value
    Object.defineProperty @prototype, name, options

  constructor: (attributes) ->
    @attributes = {}
    # Copy in attributes passed in or defaults from the fields as appropriate
    for name, options of @constructor.fields
      # Defaults can be specified as values or as functions
      @attributes[name] = attributes?[name] || if (isFunction(options.default)) then options.default() else options.default
    @listeners = {}

  # Events
  bind: (event, listener) =>
    (@listeners[event] ?= []).push(listener)
  unbind: (event) =>
    remove @listener[event]
  emit: (event, args...) =>
    listener(args...) for listener in @listeners[event] if @listeners[event]

module.exports = Model