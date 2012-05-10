
ObjectAbstract = require 'ObjectAbstract'

class CollectionAbstract extends ObjectAbstract

  length = 0

  # -----------------------------------

  _items = {}

  # -----------------------------------

  _lastIndex = -1

  # -----------------------------------
  
  add: (item) ->
    #
    # adds an item to the collection
    #
    throw "Tried to add undefined value to the collection" if item is undefined

    #
    # check if item has a getId method and use it for id, otherwise use index
    #
    if typeof item.getId is 'function'
      id = item.getId()
    else
      @_lastIndex += 1
      id = @_lastIndex

    #
    # no overriding!
    #
    throw "Item #{id} already exists in the collection!" if @_items[id] isnt undefined

    @_items[id] = item

    #
    # increase collection lenght
    #
    @length += 1

    @trigger('add', item)

    return id

  # -----------------------------------

  has: (id) ->
    #
    # checks if an item exists in the collection
    #
    return true if @_items[id] isnt undefined

    return false

  # -----------------------------------

  get: (id) ->
    #
    # returns an item with a given id, otherwise returns null
    #
    return null if @_items[id] is undefined

    return @_items[id]

  # -----------------------------------

  remove: (id) ->
    #
    # removes an item from the collection
    #
    return false if @_items[id] is undefined

    item = @_items[id]

    delete @_items[id]

    #
    # decrease collection length
    #
    @length -= 1

    @trigger('remove', item)

    return true

  # -----------------------------------

  reset: (items) ->
    #
    # resets the collection and populates it with new items if given
    #
    tempCache = @_items

    @length = 0
    @_lastIndex = -1
    @_items = {}

    #
    # trigger remove event for all wiped items
    #
    @trigger('remove', item) for id, item of tempCache

    if items isnt undefined and items instanceof Array
      @add(item) for item in items

    @trigger('reset', @)

  # -----------------------------------

  each: (callback) ->
    #
    # calls the callback function on all items of the collection
    #
    throw "Callback must be a function" if typeof callback isnt 'function'

    callback(item, id) for id, item of @_items

    return @length


############################

#
# export the class in the module
#
module.exports = CollectionAbstract