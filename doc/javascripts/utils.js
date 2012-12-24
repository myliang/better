// Generated by CoffeeScript 1.3.3
(function() {
  var $, util;

  util = {
    data: function(_self, key, value_callback) {
      var cache;
      cache = _self.data(key);
      if (cache == null) {
        cache = value_callback.call(_self);
        _self.data(key, cache);
      }
      return cache;
    },
    loading: function(obj) {
      this.target = obj;
      this.old = obj.text().replace(/(\r|\n|\r\n|\s)+/g, '');
      obj.addClass('disabled');
      obj.html(obj.html().replace(this.old, "&bull;&nbsp;&bull;&nbsp;&bull;"));
      return this;
    },
    unempty: function(obj) {
      return (obj != null) && !/^\s+$/.test(obj);
    },
    scroll: function() {
      return {
        w: $(document.body)[0].scrollWidth,
        h: $(document.body)[0].scrollHeight
      };
    },
    offset: function(source, target, arrow) {
      this.source = arguments[0].offset();
      this.source.w = arguments[0].outerWidth();
      this.source.h = arguments[0].outerHeight();
      this.target = {
        w: arguments[1].width(),
        h: arguments[1].height(),
        outer: {
          w: arguments[1].outerWidth(),
          h: arguments[1].outerHeight()
        }
      };
      this.target.padding = {
        w: this.target.outer.w - this.target.w,
        h: this.target.outer.h - this.target.h
      };
      this.arrow_size = arguments[2];
      this.scroll = util.scroll();
      if (arguments.length >= 4) {
        this.content = {
          w: arguments[3].outerWidth(),
          h: arguments[3].outerHeight()
        };
        this.target.outer.w = this.content.w + this.target.padding.w;
        this.target.outer.h = this.content.h + this.target.padding.h;
      }
      return this;
    }
  };

  util.loading.prototype = {
    recover: function() {
      return this.target.html(this.old);
    }
  };

  util.offset.prototype = {
    arrow: function(pos) {
      var border, ret;
      ret = {
        left: 0,
        top: 0,
        position: "absolute"
      };
      border = 1;
      switch (pos) {
        case "left":
          ret.left = this.source.left - this.arrow_size - border;
          ret.top = this.source.top + this.source.h / 2;
          break;
        case "right":
          ret.left = this.source.left + this.source.w + this.arrow_size + border;
          ret.top = this.source.top + this.source.h / 2;
          break;
        case "top":
          ret.left = this.source.left + this.source.w / 2;
          ret.top = this.source.top - this.arrow_size - border;
          break;
        case "bottom":
          ret.top = this.source.top + this.source.h + this.arrow_size + border;
          ret.left = this.source.left + this.source.w / 2;
      }
      return ret;
    },
    auto: function() {
      var h, w, w1;
      h = this.source.top / (this.scroll.h - this.source.top);
      w = this.source.left / (this.scroll.w - this.source.left);
      w1 = this.scroll.w - this.source.left;
      if (this.source.left > 0) {
        w1 = w1 / this.source.left;
      }
      if (h > w) {
        if (h > w1) {
          return "top";
        } else {
          return "right";
        }
      } else {
        if (h > w1) {
          return "left";
        } else {
          return "bottom";
        }
      }
    },
    center: function() {
      var ret;
      ret = {
        top: 0,
        left: 0
      };
      if (this.scroll.h > this.target.outer.h) {
        ret.top = (this.scroll.h - this.target.outer.h) / 2;
      }
      if (this.scroll.w > this.target.outer.w) {
        ret.left = (this.scroll.w - this.target.outer.w) / 2;
      }
      return this._wrap_result(ret);
    },
    top: function() {
      var ret;
      ret = {
        top: this.source.top - this.target.outer.h - this.arrow_size
      };
      return this._top_bottom(ret);
    },
    bottom: function() {
      var ret;
      ret = {
        top: this.source.top + this.source.h + this.arrow_size
      };
      return this._top_bottom(ret);
    },
    left: function() {
      var ret;
      ret = {
        left: this.source.left - this.target.outer.w - this.arrow_size
      };
      return this._left_right(ret);
    },
    right: function() {
      var ret;
      ret = {
        left: this.source.left + this.source.w + this.arrow_size
      };
      return this._left_right(ret);
    },
    _left_right: function(opt) {
      var muti;
      opt.top = this.source.top + this.source.h / 2 - this.target.outer.h / 2;
      muti = opt.top + this.target.outer.h - this.scroll.h;
      if (opt.top < 0) {
        opt.top = 0;
      } else if (muti > 0) {
        opt.top -= muti;
      }
      return this._wrap_result(opt);
    },
    _top_bottom: function(opt) {
      var muti;
      opt.left = this.source.left + this.source.w / 2 - this.target.outer.w / 2;
      muti = opt.left + this.target.outer.w - this.scroll.w;
      if (opt.left < 0) {
        opt.left = 0;
      } else if (muti > 0) {
        opt.left -= muti;
      }
      return this._wrap_result(opt);
    },
    _wrap_result: function(opt) {
      opt.w = this.target.w;
      opt.h = this.target.h;
      if (this.content != null) {
        opt.w = this.content.w;
        opt.h = this.content.h;
      }
      opt.position = "absolute";
      return opt;
    }
  };

  window.util = util;

  $ = jQuery;

  $.fn.wrapData = function(key, callback) {
    return util.data(this, key, callback);
  };

  $.fn.outerHtml = function() {
    return $('<div>').append(this.eq(0).clone().show()).html();
  };

  $.fn.rebind = function(event_name, func) {
    return this.unbind(event_name).bind(event_name, func);
  };

}).call(this);
