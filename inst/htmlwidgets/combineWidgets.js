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
        var html = "";
        html += '<div class="cw-container">';
        for (var i = 0; i < nWidgets; i++) {
          html += '<div class="cw-row" style="flex:1"><div  id="' + x.elementId[i] + '" class="cw-widget"></div></div>';
        }
        html += '</div>';
        el.innerHTML = html;

        for (i = 0; i < nWidgets; i++) {
          var child = document.getElementById(x.elementId[i]);
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
