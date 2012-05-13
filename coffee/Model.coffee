
ObjectAbstract = require('abstracts').ObjectAbstract

#
# an internal counter, will give each model with idAttribute option set to null a unique id
#
autoIncrementId = 1

class Model extends ObjectAbstract
  #
  # only models can be added to a collection, this property is used by collection to check if an object is a model
  #
  _isModel: true

  # -----------------------------------

  _attributes: {}

  # -----------------------------------

  _changes: {}

  # -----------------------------------

  id: null

  # -----------------------------------

  options:
    idAttribute: null

  # -----------------------------------

  constructor: (attributes, options) ->
    @setOptions(options)
    @set(attributes)

    #
    # if idAttribute option is set and the attribute exists, use it as an id
    #
    if typeof @options.idAttribute is 'string' and @_attributes[@options.idAttribute] isnt undefined
      @id = @_attributes[@options.idAttribute]

    #
    # otherwise use auto
    #
    else
      @id = autoIncrementId
      autoIncrementId += 1

  # -----------------------------------

  set: (attributes, value) ->
    if typeof attributes is 'string' and value isnt undefined
      #
      # model.set("key", value) call
      #
      if @_attributes[attributes] isnt value
        @_attributes[attributes] = value
        @_changes[attributes] = value

        @trigger('change:'+attributes)
        @trigger('change')

      return true

    else if typeof attributes is 'object' and value is undefined
      #
      # model.set("key": value, ...) call
      #
      changed = false
      for key, value of attributes
        if typeof key is 'string' and @_attributes[attributes] isnt value
          @_attributes[key] = value
          @_changes[key] = value

          changed = true
          @trigger('change:'+key)

      @trigger('change') if changed

      return true

    return false

  # -----------------------------------

  get: (attribute) ->
    return @_attributes[attribute] if @_attributes[attribute] isnt undefined
    return null

  # -----------------------------------

  destroy: ->
    #
    # destroys the model, removing it from all collections
    #
    @trigger('destroy', model.id)

  # -----------------------------------

  getChanges: ->
    #
    # returns a hash of all changes to the model since creation *or* previous getChanges() call,
    # useful for db queries
    #
    temp = @_changes
    @_changes = {}
    return temp

  # -----------------------------------

  toJSON: ->
    #
    # to use with JSON.stringify, usually you won't need to use this method directly
    #
    return @_attributes

############################

#
# export the class in the module
#
module.exports = Model