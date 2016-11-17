HTMLWidgets.widget({

  name: 'combineWidgets',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    function getWidgetFactory(name) {
      return HTMLWidgets.widgets.filter(function(x) {return x.name == name})[0];
    }

    return {

      renderValue: function(x) {
        var nWidgets = x.widgetType.length;
        window.x = x;
        // Initialize html
        for (var i = 0; i < nWidgets; i++) {
          el.innerHTML += '<div style="width:100%;height:' + (100 /nWidgets) + '%;float:left;padding:5px;box-sizing: border-box;"><div id="widget' + i + '" style="width:100%;height:100%"></div></div>';
        }

        for (i = 0; i < nWidgets; i++) {
          var child = document.getElementById("widget" + i);
          var widgetFactory = getWidgetFactory(x.widgetType[i]);
          var w = widgetFactory.initialize(child, "100%", (100 /nWidgets) + "%");
          widgetFactory.renderValue(child, x.data[i], w);
        }

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
