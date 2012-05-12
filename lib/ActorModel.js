// Generated by CoffeeScript 1.3.2-pre
var ActorModel, Model,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Model = require('Model');

ActorModel = (function(_super) {

  __extends(ActorModel, _super);

  function ActorModel() {
    return ActorModel.__super__.constructor.apply(this, arguments);
  }

  ActorModel.prototype.play = function(action) {
    action.run(this);
    return this.trigger('play', action);
  };

  return ActorModel;

})(Model);

module.exports = ActorModel;