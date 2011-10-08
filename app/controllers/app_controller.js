var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Fraktioncalculator.AppController = (function() {
  __extends(AppController, Batman.Controller);
  function AppController() {
    this.reedit = __bind(this.reedit, this);
    this.shortening = __bind(this.shortening, this);
    this.clear = __bind(this.clear, this);
    this.edit = __bind(this.edit, this);
    this.create = __bind(this.create, this);
    this.reset = __bind(this.reset, this);
    AppController.__super__.constructor.apply(this, arguments);
  }
  AppController.prototype.calc = null;
  AppController.prototype.index = function() {
    $('#container').fadeIn(1000);
    $('#operators').selectable();
    this.set('calc', new Calculation);
    return this.render(false);
  };
  AppController.prototype.setOperator = function(e, ui) {
    this.set('calc.operator', $(ui.selected).text());
    return console.log(this.get('calc.operator'));
  };
  AppController.prototype.reset = function() {
    return this.set('calc', new Calculation({
      operator: this.get('calc.operator'),
      shortening: this.get('calc.shortening')
    }));
  };
  AppController.prototype.create = function() {
    return this.calc.save(__bind(function(error, record) {
      var x;
      if (error) {
        throw error;
      }
      x = Calculation.all.toArray();
      x = x[x.length - 1];
      this.set('calc', new Calculation({
        operator: this.get('calc.operator'),
        shortening: this.get('calc.shortening'),
        denominator1: x.get('denominatorResult'),
        numerator1: x.get('numeratorResult')
      }));
      return $('#calculations').scrollTop(9999);
    }, this));
  };
  AppController.prototype.edit = function() {
    return this.set('calc', new Calculation);
  };
  AppController.prototype.clear = function() {
    var i, _i, _len, _ref, _results;
    _ref = Calculation.all.toArray();
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      _results.push(i.destroy());
    }
    return _results;
  };
  AppController.prototype.shortening = function() {
    return this.set('calc.shortening', !this.get('calc.shortening'));
  };
  AppController.prototype.reedit = function(el, evt) {
    var $elems, $ops, i, m, o, op, x, _i, _len, _ref, _ref2;
    $elems = $('.calc');
    for (i = 0, _ref = $elems.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      if (el === $elems[i]) {
        x = i;
        break;
      }
    }
    m = Calculation.all.toArray()[x];
    if (m) {
      op = m.get('operator');
      $ops = $('#operators');
      this.set('calc', new Calculation({
        denominator1: m.get('denominator1'),
        denominator2: m.get('denominator2'),
        numerator1: m.get('numerator1'),
        numerator2: m.get('numerator2'),
        operator: op,
        shortening: this.get('calc.shortening')
      }));
      $ops.find('.ui-selected').removeClass('ui-selected');
      _ref2 = $ops.children();
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        o = _ref2[_i];
        if ($(o).html() === op) {
          console.log(op);
          $(o).addClass('ui-selected');
        }
      }
      return m.destroy();
    }
  };
  return AppController;
})();