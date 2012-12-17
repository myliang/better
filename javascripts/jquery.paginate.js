// Generated by CoffeeScript 1.3.3
(function() {
  var $, cache_objects, _paginate;

  $ = jQuery;

  cache_objects = [];

  _paginate = function(_self, option) {
    var at;
    $.extend(this, option);
    this.self = $(_self);
    at = this;
    $('a', this.self).on(this.trigger, function() {
      at.go(this);
      return false;
    });
    if (this.url != null) {
      this.step(0);
    }
    return this;
  };

  _paginate.prototype = {
    go: function(node) {
      var self_p;
      try {
        self_p = $(node).parent();
        if (self_p.is(this.except)) {
          return;
        }
        if (self_p.hasClass('prev')) {
          this.prev();
        } else if (self_p.hasClass('next')) {
          this.next();
        }
      } catch (error) {

      }
      return this;
    },
    next: function() {
      if (!this.is_next()) {
        return;
      }
      return this.step(1);
    },
    prev: function() {
      if (!this.is_prev()) {
        return;
      }
      return this.step(-1);
    },
    step: function(offset) {
      var params,
        _this = this;
      this.page += offset;
      this.loading = new util.loading(this.self);
      params = {};
      params[this.page_name] = this.page;
      $.get(this.url + this.url_suffix, params, function() {
        return _this.get_after();
      }).error(function() {
        return _this.get_after();
      });
      return this;
    },
    is_prev: function() {
      return this.page > 1;
    },
    is_next: function() {
      var total_pages, _ref;
      total_pages = this.total_rows / this.page_rows + ((_ref = this.total_rows % this.page_rows > 0) != null ? _ref : {
        1: 0
      });
      return this.page < total_pages;
    },
    get_after: function(data) {
      this.page_rows || (this.page_rows = data.per_page);
      this.total_rows || (this.total_rows = data.total_pages);
      this.after(data);
      this.set_other();
      return this.loading.recover();
    },
    set_other: function() {
      var n, p;
      p = $('.prev a', this.self);
      n = $('.next a', this.self);
      $('.current a', this.self).text(this.page);
      if (this.is_prev()) {
        if (p.hasClass('disabled')) {
          p.removeClass('disabled');
        }
      } else {
        p.addClass('disabled');
      }
      if (this.is_next()) {
        if (n.hasClass('disabled')) {
          return n.removeClass('disabled');
        }
      } else {
        return n.addClass('disabled');
      }
    }
  };

  $.fn.paginate = function(option) {
    option = $.extend({}, $.fn.paginate.defaults, option || {});
    this.each(function() {
      return $(this).wrapData(option.cache_key_suffix, function() {
        return new _paginate(this, option);
      });
    });
    return this;
  };

  $.fn.paginate.defaults = {
    url: null,
    except: ".disabled",
    url_suffix: ".json",
    page: 1,
    page_rows: 20,
    total_rows: null,
    cache_key_suffix: 'paginate',
    trigger: 'click',
    page_name: 'page',
    trigger_name: function() {
      return this.trigger;
    },
    after: function() {}
  };

}).call(this);
