
ObjectAbstract = require('abstracts').ObjectAbstract
Model = require('Model')

class CollectionAbstract extends ObjectAbstract

  length: 0

  # -----------------------------------

  _modelsHash: {}

  # -----------------------------------

  models: []

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

    #
    # comparator for sorting should be a string with attribute key by which models should be sorted,
    #   or
    # a function taking one model as argument and returning value by which the models should be sorted,
    #   or
    # a function taking two models and returning a positive number, negative number or 0
    #
    comparator: null

    #
    # reverse sorting flag
    #
    reverseSort: false

  # -----------------------------------

  _filterFromArray: (array, element) ->
    x for x in array when x isnt element

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
    throw "Model #{model.id} already exists in the collection!" if @_modelsHash[model.id] isnt undefined

    #
    # put the model into the hash and array
    #
    @_modelsHash[model.id] = model
    @models.push(model)

    #
    # increase collection lenght
    #
    @length += 1

    #
    # remove model from collection if a destroy event is triggered on it!
    #
    model.on('destroy', (id) => @remove(id))

    @trigger('add', model)

    #
    # auto sort the collection
    #
    @sort() if @options.comparator?

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
    return true if @_modelsHash[id] isnt undefined

    return false

  # -----------------------------------

  at: (index) ->
    return @models[index] if @models[index] isnt undefined
    return null

  # -----------------------------------

  get: (id) ->
    #
    # returns a model with a given id, otherwise returns null
    #
    return null if @_modelsHash[id] is undefined

    return @_modelsHash[id]

  # -----------------------------------

  remove: (id) ->
    #
    # removes a model from the collection
    #
    return false if @_modelsHash[id] is undefined

    model = @_modelsHash[id]

    #
    # remove the model from the hash
    #
    delete @_modelsHash[id]

    #
    # remove the model from the array
    #
    @models = @_filterFromArray(@models, model)

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
    tempCache = @_modelsHash

    @length = 0
    @_lastIndex = -1
    @_modelsHash = {}

    #
    # trigger remove event for all wiped items
    #
    @trigger('remove', model) for id, model of tempCache

    if data isnt undefined and data instanceof Array
      @add(item) for item in data

    @trigger('reset')

  # -----------------------------------

  sort: ->
    #
    # sorts the collection using comparator
    #
    throw "Tried to sort the collection without a comparator" if typeof @options.comparator not in ['function', 'string']

    #
    # if comparator is an attribute string, then create a function for it
    #
    if typeof @options.comparator is 'string'
      comparator = (model) -> model.get('string')
    else
      comparator = @options.comparator

    if comparator.lenght is 1
      #
      # sort by a poperty of the model
      #
      @models.sort (left, right) ->
        a = comparator(left)
        b = comparator(right)

        if a < b
          -1
        else if a > b
          1
        else
          0

    else if comparator.length is 2
      #
      # regular sort with comparator
      #
      @models.sort(comparator)

    @models.reverse() if @options.reverseSort is true

  # -----------------------------------

  each: (callback) ->
    #
    # calls the callback function on all models of the collection
    #
    throw "Callback must be a function" if typeof callback isnt 'function'

    callback(model) for model in @models

    return @length

  # -----------------------------------

  filter: (filterCallback) ->
    #
    # returns an array of all models matching the filter
    #
    model for model in @models when filterCallback(model)


############################

#
# export the class in the module
#
module.exports = CollectionAbstract