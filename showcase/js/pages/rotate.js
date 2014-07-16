// Generated by CoffeeScript 1.7.1
(function() {
  var RotatePage;

  RotatePage = (function() {
    RotatePage.prototype.cars = {
      ceed: {
        image: 'img/3d/ceed.png'
      },
      ceed_pro: {
        image: 'img/3d/ceed_pro.png'
      }
    };

    RotatePage.prototype.current = 'ceed';

    RotatePage.prototype.currentMedia = null;

    function RotatePage() {
      this.links = $('.carTitles a');
      this._init();
    }

    RotatePage.prototype._init = function() {
      this.container = $('#rotateContainer');
      this.arrows = this.container.closest('.rotateWrapper').find('.rotateArrows');
      this.arrows.hide();
      this._initRotate();
      this._initEvents();
      this._detectCurrentMedia();
      return window.Animation.addResizeCallback((function(_this) {
        return function() {
          return _this._resize();
        };
      })(this));
    };

    RotatePage.prototype._initRotate = function() {
      var src;
      this.container.addClass(this.current);
      this.wrapper = this.container.closest('.rotateWrapper');
      this.wrapper.css('opacity', 0);
      src = $('#rotateContainer').css('background-image');
      if (typeof src === "string") {
        src = src.replace(/^url\(["']?/, '').replace(/["']?\)$/, '');
      }
      return this.container.spritespin({
        source: src,
        width: parseInt(this.container.css('min-width')),
        height: parseInt(this.container.css('min-height')),
        frames: 24,
        framesX: 6,
        loop: false,
        animate: false,
        renderer: 'background',
        onInit: (function(_this) {
          return function(event) {
            _this._showArrows();
            _this.api = _this.container.spritespin('api');
            _this.api.updateFrame(5);
            return $(_this.wrapper).animate({
              opacity: 1
            }, {
              duration: 1000
            });
          };
        })(this)
      });
    };

    RotatePage.prototype._initEvents = function() {
      $('.left', this.arrows).on('click', (function(_this) {
        return function(event) {
          event.preventDefault();
          return _this.api.nextFrame();
        };
      })(this));
      $('.right', this.arrows).on('click', (function(_this) {
        return function(event) {
          event.preventDefault();
          return _this.api.prevFrame();
        };
      })(this));
      return $('a', '.carTitles').on('click', (function(_this) {
        return function(event) {
          var link, target, ul;
          event.preventDefault();
          link = $(event.currentTarget);
          target = link.attr('href').replace('#', '');
          ul = $(event.target).closest('ul');
          _this.links.removeClass('active');
          $(link).addClass('active');
          _this.container.removeClass('ceed ceed_pro').addClass(target);
          return $(_this.wrapper).animate({
            opacity: 0
          }, {
            duration: 1000,
            complete: function() {
              _this.container.spritespin('destroy');
              return _this._initRotate();
            }
          });
        };
      })(this));
    };

    RotatePage.prototype._showArrows = function() {
      return this.arrows.fadeIn('slow');
    };

    RotatePage.prototype._resize = function() {
      this.previousMedia = this.currentMedia;
      this._detectCurrentMedia();
      if (this.previousMedia !== this.currentMedia) {
        clearTimeout(this.timeout);
        return this.timeout = setTimeout((function(_this) {
          return function() {
            _this.container.spritespin('destroy');
            return _this._initRotate();
          };
        })(this), 100);
      }
    };

    RotatePage.prototype._detectCurrentMedia = function() {
      if (parseInt($('body').css('min-height')) === 0) {
        return this.currentMedia = 'normal';
      } else {
        return this.currentMedia = 'big';
      }
    };

    return RotatePage;

  })();

  $(function() {
    return window.rotatePage = new RotatePage();
  });

}).call(this);

//# sourceMappingURL=rotate.map
