var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Fraktioncalculator.Calculation = (function() {
  __extends(Calculation, Batman.Model);
  function Calculation() {
    Calculation.__super__.constructor.apply(this, arguments);
  }
  Calculation.persist(Batman.LocalStorage);
  Calculation.encode('operator', 'denominator1', 'denominator2', 'numerator1', 'numerator2');
  Calculation.global(true);
  Calculation.prototype.operator = '+';
  Calculation.accessor('showNo_fraktion', function() {
    var den, num;
    den = this.get('denominatorView');
    num = this.get('numeratorView');
    return den === 0 || num === 0 || num === 1;
  });
  Calculation.accessor('noFraktion', function() {
    if (this.get('numeratorResult') === 0) {
      return 0;
    } else {
      return this.get('denominatorResult');
    }
  });
  Calculation.accessor('negative', function() {
    var den, num;
    den = this.get('denominatorResult') >= 0;
    num = this.get('numeratorResult') >= 0;
    return den + num === 1;
  });
  Calculation.prototype.shortening = false;
  Calculation.prototype.denominator1 = '1';
  Calculation.prototype.denominator2 = '1';
  Calculation.prototype.denominatorOperators = {
    '+': function(n1, n2, z1, z2) {
      if (z1 !== z2) {
        return n1 * z2 + n2 * z1;
      } else {
        return n1 + n2;
      }
    },
    '-': function(n1, n2, z1, z2) {
      if (z1 !== z2) {
        return n1 * z2 - n2 * z1;
      } else {
        return n1 - n2;
      }
    },
    'x': function(n1, n2) {
      return n1 * n2;
    },
    ':': function(n1, n2, z1, z2) {
      return n1 * z2;
    }
  };
  Calculation.accessor('denominatorResult', function() {
    var res;
    res = this.get('denominatorOperators')[this.get('operator')](Number(this.get('denominator1')), Number(this.get('denominator2')), Number(this.get('numerator1')), Number(this.get('numerator2')));
    return res || 0;
  });
  Calculation.accessor('denominatorView', function() {
    var a, b, den, num, _ref, _results;
    den = Math.sqrt(Math.pow(this.get('denominatorResult'), 2));
    num = Math.sqrt(Math.pow(this.get('numeratorResult'), 2));
    if (this.get('shortening')) {
      a = den;
      b = num;
      _results = [];
      while (true) {
        _ref = [b, a % b], a = _ref[0], b = _ref[1];
        if (b === 0) {
          return den / a;
          break;
        }
      }
      return _results;
    } else {
      return den;
    }
  });
  Calculation.prototype.numerator1 = '1';
  Calculation.prototype.numerator2 = '1';
  Calculation.prototype.numeratorOperators = {
    '+': function(n1, n2, z1, z2) {
      if (z1 !== z2) {
        return z1 * z2;
      } else {
        return z1;
      }
    },
    '-': function(n1, n2, z1, z2) {
      if (z1 !== z2) {
        return z1 * z2;
      } else {
        return z1;
      }
    },
    'x': function(n1, n2, z1, z2) {
      return z1 * z2;
    },
    ':': function(n1, n2, z1, z2) {
      return z1 * n2;
    }
  };
  Calculation.accessor('numeratorResult', function() {
    var res;
    res = this.get('numeratorOperators')[this.get('operator')](Number(this.get('denominator1')), Number(this.get('denominator2')), Number(this.get('numerator1')), Number(this.get('numerator2')));
    return res || 0;
  });
  Calculation.accessor('numeratorView', function() {
    var a, b, den, num, _ref, _results;
    den = Math.sqrt(Math.pow(this.get('denominatorResult'), 2));
    num = Math.sqrt(Math.pow(this.get('numeratorResult'), 2));
    if (this.get('shortening')) {
      a = den;
      b = num;
      _results = [];
      while (true) {
        _ref = [b, a % b], a = _ref[0], b = _ref[1];
        if (b === 0) {
          return num / a;
          break;
        }
      }
      return _results;
    } else {
      return num;
    }
  });
  return Calculation;
})();