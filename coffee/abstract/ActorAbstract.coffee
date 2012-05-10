
ObjectAbstract = require 'ObjectAbstract'

class ActorAbstract extends ObjectAbstract

  play: (action) ->
    #
    # run the action on the actor
    #
    action.run(@)

    @trigger('play', action)


############################

#
# export the class in the module
#
module.exports = ActorAbstract