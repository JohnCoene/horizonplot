HTMLWidgets.widget({

  name: 'horizon',

  type: 'output',

  factory: function(el, width, height) {

    var chart,
        dom,
        data;

    return {

      renderValue: function(x) {

        for (i = 0; i < x.data.length; i++) {
          x.data[i][x.ts] = new Date(x.data[i][x.ts])
        }

        console.log(x.data)

        dom = document.getElementById(el.id);
        chart = HorizonTSChart();
        chart
            .data(x.data)
            .series(x.series)
            .ts(x.ts)
            .val(x.val)
            (dom);

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});