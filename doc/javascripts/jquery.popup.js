// Generated by CoffeeScript 1.3.3
(function() {
  var $, cache_objects, _popup;

  $ = jQuery;

  cache_objects = [];

  _popup = function(self, option) {
    $.extend(this, option);
    this.self = $(self);
    return this;
  };

  _popup.prototype = {
    toggle: function() {
      if (this.self.is(this.except)) {
        return;
      }
      if (!this.self.hasClass('active')) {
        this.show();
      } else {
        this.hide();
      }
      return this;
    },
    show: function() {
      var offset, temp_offset,
        _this = this;
      this.body = this.get_content();
      this.arrow_doc = $("<div class=\"" + this.arrow_doc_class + "\"></div>");
      $(document.body).append(this.body).append(this.arrow_doc);
      this.body.off('click').on('click', function() {
        return false;
      });
      $('.close', this.body).off('click').on('click', function() {
        _this.hide();
        return false;
      });
      offset = new util.offset(this.self, this.body, this.offset);
      temp_offset = offset[this.direction]();
      if (this.direction === "auto") {
        this.direction = temp_offset;
        temp_offset = offset[temp_offset]();
      } else {
        temp_offset;

      }
      this.arrow_doc.addClass(this.direction).css(offset.arrow(this.direction));
      this.body.css(temp_offset).show();
      this.self.addClass('active');
      return this;
    },
    hide: function() {
      if (this.is_remove_if_hide) {
        this.body.remove();
      } else {
        this.body.hide();
      }
      this.arrow_doc.remove();
      this.self.removeClass('active');
      return this;
    },
    get_content: function() {
      var href, is_remove_if_hide;
      href = this.self.attr('href');
      if (typeof this.content === "function") {
        return this.default_content(this.content.call(this.self));
      } else if (typeof this.content === "object" && (this.content != null)) {
        return this.content;
      } else if ((href != null) && href.length > 1 && href[0] === "#") {
        is_remove_if_hide = true;
        return $(href);
      } else {
        return this.default_content();
      }
    },
    default_content: function() {
      var content, title;
      title = this.self.attr('data-title');
      if (title == null) {
        title = "提示信息";
      }
      if (arguments.length <= 0) {
        content = this.self.attr('data-content');
      } else {
        content = arguments[0];
      }
      if (title != null) {
        title = "<div class=\"header\">" + title + "<a href=\"#\" class=\"close\">&times</a></div>";
      } else {
        title = "";
      }
      content = $("<div style=\"display: none; max-width: " + this.max_width + "\">\n  <div class=\"popup border\">\n    " + title + "\n    <div class=\"body\">\n      " + content + "\n    </div>\n  </div>\n</div>");
      return content;
    }
  };

  $.fn.popup = function(option) {
    var binder;
    option = $.extend({}, $.fn.popup.defaults, option || {});
    binder = option.live ? "live" : "bind";
    return this[binder](option.trigger_name(), function() {
      var p;
      p = $(this).wrapData(option.cache_key_suffix, function() {
        return new _popup(this, option);
      });
      cache_objects.push(p);
      p.toggle();
      return false;
    });
  };

  $.fn.popup.defaults = {
    cache_key_suffix: "popup",
    direction: "auto",
    live: false,
    trigger: "click",
    offset: 10,
    except: '.disabled,:disabled,:animated',
    content: null,
    is_remove_if_hide: true,
    arrow_doc_class: "arrow-popup",
    max_width: "660px",
    trigger_name: function() {
      return this.trigger + "." + this.cache_key_suffix;
    },
    after: {
      show: function() {},
      hide: function() {}
    }
  };

  $.fn.popup.constructor = _popup;

  $(document).on('click', function() {
    $.each(cache_objects, function(index, ele) {
      return ele.hide();
    });
    return cache_objects = [];
  });

}).call(this);
