
CollectionAbstract = require 'CollectionAbstract'

#
# a room is a collection of actors
#
class RoomAbstract extends CollectionAbstract

  propagate: (action) ->
    #
    # propagate an action object through the room
    #
    @each (actor) => actor.play(action)

    #
    # trigger an event!
    #
    @trigger('propagate', action)


############################

#
# export the class in the module
#
module.exports = RoomAbstract