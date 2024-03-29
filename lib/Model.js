// Generated by CoffeeScript 1.3.2-pre
var Model, ObjectAbstract, autoIncrementId,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ObjectAbstract = require('abstracts').ObjectAbstract;

autoIncrementId = 1;

Model = (function(_super) {

  __extends(Model, _super);

  Model.prototype._isModel = true;

  Model.prototype._attributes = {};

  Model.prototype._changes = {};

  Model.prototype.id = null;

  Model.prototype.options = {
    idAttribute: null
  };

  function Model(attributes, options) {
    this.setOptions(options);
    this.set(attributes);
    if (typeof this.options.idAttribute === 'string' && this._attributes[this.options.idAttribute] !== void 0) {
      this.id = this._attributes[this.options.idAttribute];
    } else {
      this.id = autoIncrementId;
      autoIncrementId += 1;
    }
  }

  Model.prototype.set = function(attributes, value, options) {
    var changed, key;
    if (typeof attributes === 'string' && value !== void 0) {
      options || (options = {});
      key = attributes;
      if (this._attributes[key] !== value) {
        this._attributes[key] = value;
        this._changes[key] = value;
        if (options.silent !== true) {
          this.trigger('change:' + key);
          this.trigger('change');
        }
      }
      return true;
    } else if (typeof attributes === 'object' && options === void 0) {
      options = value || {};
      changed = false;
      for (key in attributes) {
        value = attributes[key];
        if (typeof key === 'string' && this._attributes[attributes] !== value) {
          this._attributes[key] = value;
          this._changes[key] = value;
          if (options.silent !== true) {
            changed = true;
            this.trigger('change:' + key);
          }
        }
      }
      if (changed) {
        this.trigger('change');
      }
      return true;
    }
    return false;
  };

  Model.prototype.get = function(attribute) {
    if (this._attributes[attribute] !== void 0) {
      return this._attributes[attribute];
    }
    return null;
  };

  Model.prototype.destroy = function(options) {
    options || (options = {});
    if (options.silent !== true) {
      return this.trigger('destroy', model.id);
    }
  };

  Model.prototype.getChanges = function() {
    var temp;
    temp = this._changes;
    this._changes = {};
    return temp;
  };

  Model.prototype.toJSON = function() {
    return this._attributes;
  };

  return Model;

})(ObjectAbstract);

module.exports = Model;
