
ObjectAbstract = require('abstract').ObjectAbstract
Model = require('Model')

class CollectionAbstract extends ObjectAbstract

  length: 0

  # -----------------------------------

  _models: {}

  # -----------------------------------

  options:
    #
    # a class to be used with
    #
    model: Model
    #
    # analog to idAttribute option of  model, will be used when creating models with the create method
    #
    idAttribute: null

  # -----------------------------------

  constructor: (options) ->
    @setOptions(options)

  # -----------------------------------

  add: (data) ->
    #
    # adds a model to the collection
    #
    throw "Tried to add #{typeof data} value to the collection, expected object" if typeof data isnt 'object'

    #
    # checks if what we got is an actual model or data set, if latter then create a model out of it!
    #
    if data._isModel isnt true
      model = @create(data)
    else
      model = data

    #
    # no overriding!
    #
    throw "Model #{model.id} already exists in the collection!" if @_models[model.id] isnt undefined

    @_models[model.id] = model

    #
    # increase collection lenght
    #
    @length += 1

    @trigger('add', model)

    return model.id

  # -----------------------------------

  create: (attributes) ->
    #
    # create a model with provided attributes
    #
    return new @options.model(attributes, idAttribute: @options.idAttribute)

  # -----------------------------------

  has: (id) ->
    #
    # checks if a model exists in the collection
    #
    return true if @_models[id] isnt undefined

    return false

  # -----------------------------------

  get: (id) ->
    #
    # returns a model with a given id, otherwise returns null
    #
    return null if @_models[id] is undefined

    return @_models[id]

  # -----------------------------------

  remove: (id) ->
    #
    # removes a model from the collection
    #
    return false if @_models[id] is undefined

    model = @_models[id]

    delete @_models[id]

    #
    # decrease collection length
    #
    @length -= 1

    @trigger('remove', model)

    return true

  # -----------------------------------

  reset: (data) ->
    #
    # resets the collection and populates it with new data if given
    #
    tempCache = @_models

    @length = 0
    @_lastIndex = -1
    @_models = {}

    #
    # trigger remove event for all wiped items
    #
    @trigger('remove', model) for id, model of tempCache

    if data isnt undefined and data instanceof Array
      @add(item) for item in data

    @trigger('reset')

  # -----------------------------------

  each: (callback) ->
    #
    # calls the callback function on all models of the collection
    #
    throw "Callback must be a function" if typeof callback isnt 'function'

    callback(model, id) for id, model of @_models

    return @length


############################

#
# export the class in the module
#
module.exports = CollectionAbstract