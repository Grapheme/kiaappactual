// Generated by CoffeeScript 1.7.1
(function() {
  var AnimationPopup,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  AnimationPopup = (function(_super) {
    __extends(AnimationPopup, _super);

    function AnimationPopup() {
      return AnimationPopup.__super__.constructor.apply(this, arguments);
    }

    AnimationPopup.prototype.type = 'popup';

    AnimationPopup.prototype.durations = {
      big: 1000,
      main: 700,
      small: 500,
      mirco: 200
    };

    AnimationPopup.prototype._forward = function(callback) {
      var endPosition, position;
      this.originwidth = window.Animation.originWidth;
      position = this.objects.from.width() + this.objects.from.height() / Math.cos(window.Animation.rotateAngleRad);
      endPosition = this.objects.from.width() - parseInt(this.originwidth);
      this._stepOne(position, endPosition, this.durations.main, 0, (function(_this) {
        return function() {
          return callback(_this.objects.to);
        };
      })(this));
      return this.objects.from.delay(200).animate({
        left: '-40%'
      }, {
        queue: false,
        duration: this.durations.big,
        easing: 'easeOutCubic'
      });
    };

    AnimationPopup.prototype._back = function(callback) {
      var endPosition, position;
      position = this.objects.from.width() - parseInt(this.originwidth);
      endPosition = this.objects.to.width() + this.objects.to.height() / Math.cos(window.Animation.rotateAngleRad);
      this._stepOne(position, endPosition, this.durations.big, 300, (function(_this) {
        return function() {
          return _this.objects.to.remove();
        };
      })(this));
      return this.objects.from.animate({
        left: 0
      }, {
        duration: this.durations.main,
        easing: 'easeOutQuad',
        queue: false,
        complete: function() {
          return callback();
        }
      });
    };

    AnimationPopup.prototype._stepOne = function(startPosition, endPosition, speed, delay, callback) {
      var planes;
      this.objects.to.css({
        left: startPosition
      });
      planes = window.Animation.getPlanes(this.objects.to);
      $('.planeBg', planes.right).css('right', endPosition);
      $('.planeContent', planes.right).css('margin-right', -endPosition);
      this.objects.to.show().delay(delay).animate({
        left: endPosition,
        width: this.originWidth
      }, {
        duration: speed,
        easing: 'easeOutQuad',
        complete: (function(_this) {
          return function() {
            return callback();
          };
        })(this)
      });
      $(planes.right).css({
        left: window.Animation.calc.offsetX + 20
      });
      return $('.planeBg', planes.right).css({
        display: 'block',
        opacity: 0
      }).animate({
        opacity: 1
      }, {
        duration: this.durations.small,
        queue: false
      });
    };

    AnimationPopup.prototype._alignBg = function(offset) {
      var planes;
      planes = window.Animation.getPlanes(this.objects.to);
      return $('.planeBg', planes.right).css('right', offset);
    };

    AnimationPopup.prototype._resize = function(planes) {
      var endPosition;
      planes = window.Animation.getPlanes(this.objects.to);
      window.Animation.prepare(planes, false);
      endPosition = this.objects.from.width() - parseInt(this.originwidth);
      this.objects.to.css({
        left: endPosition,
        width: this.originWidth - endPosition
      });
      $(planes.right).css({
        left: window.Animation.calc.offsetX + 20
      });
      $('.planeBg', planes.right).css('right', endPosition);
      return $('.planeContent', planes.right).css('margin-right', -endPosition);
    };

    return AnimationPopup;

  })(window.AnimationAbstract);

  $(function() {
    return window.animationTypes.popup = AnimationPopup;
  });

}).call(this);

//# sourceMappingURL=AnimationPopup.map
