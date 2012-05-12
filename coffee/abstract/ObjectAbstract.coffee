
class ObjectAbstract
  #
  # a hash with options, override with defaults in child class
  #
  options: {}

  # -----------------------------------

  _eventHandlers = {}

  # -----------------------------------

  _testEventName: (event) ->
    throw "Event name has to be a string" if typeof event isnt 'string'

  # -----------------------------------

  _testCallback: (callback) ->
    throw "Event listener callback has to be defined and be a function" if typeof callback isnt 'function'

  # -----------------------------------

  setOptions: (options) ->
    #
    # set the @option property with new options or use defaults
    #
    if options isnt undefined
      for option of @options
        @options[option] = options[option] if options[option] isnt undefined

      return true

    return false

  # -----------------------------------

  on: (event, callback) ->
    #
    # sets up an event handler for a specific event
    #
    @_testEventName(event)
    @_testCallback(callback)

    #
    # create a new stack for the callbacks if not defined yet
    #
    @_eventHandlers[event] = [] if @_eventHandlers[event] is undefined

    #
    # push the callback onto the stack
    #
    @_eventHandlers[event].push(callback)

  # -----------------------------------

  off: (event, callback) ->
    #
    # remove a given listener callback from the event
    #
    @_testEventName(event)
    @_testCallback(callback)

    return false if @_eventHandlers[event] is undefined

    for func, index in @_eventHandlers[event]
      if func is callback
        #
        # remove the listener from the stack
        #
        @_eventHandlers[event].splice(index, index)
        return true

    return false

  # -----------------------------------

  offAll: (event) ->
    #
    # remove all listeners of a given event
    #
    @_testEventName(event)

    delete @_eventHandlers[event] if @_eventHandlers[event] isnt undefined

  # -----------------------------------

  trigger: (event, data) ->
    #
    # triggers all listener callbacks of a given event, pass on the data from second argument
    #
    @_testEventName(event)

    return false if @_eventHandlers[event] is undefined

    callback(data) for callback in @_eventHandlers[event]

    return true


############################

#
# export the class in the module
#
module.exports = ObjectAbstract