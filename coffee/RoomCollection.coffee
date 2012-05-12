
Collection = require('Collection')

#
# a room is a collection of actors
#
class RoomCollection extends Collection

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
module.exports = RoomCollection