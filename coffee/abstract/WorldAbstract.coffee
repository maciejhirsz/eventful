
CollectionAbstract = require 'CollectionAbstract'

#
# a world is a collection of rooms or other worlds
#
class WorldAbstract extends CollectionAbstract

  propagate: (action) ->
    #
    # propagate an action object through the world
    #
    @each (space) => space.propagate(action)

    #
    # trigger an event!
    #
    @trigger('propagate', action)


############################

#
# export the class in the module
#
module.exports = WorldAbstract