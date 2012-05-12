
Model = require('Model')

class ActorModel extends Model

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
module.exports = ActorModel