
ObjectAbstract = require('ObjectAbstract')

class ActionAbstract extends ObjectAbstract
  
  run: (actor) ->
    #
    # Abstract method, should perfom actions on the actor
    #


############################

#
# export the class in the module
#
module.exports = ActionAbstract