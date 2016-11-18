HTMLWidgets.widget({

  name: 'combineWidgets',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    var widgets = [];

    function getWidgetFactory(name) {
      return HTMLWidgets.widgets.filter(function(x) {return x.name == name})[0];
    }

    return {

      renderValue: function(x) {
        var nWidgets = x.widgetType.length;
        if (!window.x) window.x = x;
        el.innerHTML = x.html;

        for (var i = 0; i < nWidgets; i++) {
          var child = document.getElementById(x.elementId[i]);
          var widgetFactory = getWidgetFactory(x.widgetType[i]);
          var w = widgetFactory.initialize(child, child.clientWidth, child.clientHeight);
          widgetFactory.renderValue(child, x.data[i], w);
          widgets.push({factory:widgetFactory, instance:w, el: child});
          this.resize(el.clientWidth, el.clientHeight);
        }

      },

      resize: function(width, height) {
        widgets.forEach(function(x) {
          x.factory.resize(x.el, x.el.clientWidth, x.el.clientHeight, x.instance);
        });
      }

    };
  }
});
