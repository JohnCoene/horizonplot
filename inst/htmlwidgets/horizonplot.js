HTMLWidgets.widget({

  name: 'horizonplot',

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
            .width(dom.offsetWidth)
            .height(dom.offsetHeight)
            .series(x.series)
            .ts(x.ts)
            .val(x.val)
            .useUtc(x.useUtc)
            .use24h(x.use24h)
            .horizonBands(x.horizonBands)
            .horizonMode(x.horizonMode)
            .yNormalize(x.yNormalize)
            .yScaleExp(x.yScaleExp)
            .positiveColors(x.positiveColors)
            .negativeColors(x.negativeColors)
            .showRuler(x.showRuler)
            .enableZoom(x.enableZoom)
            .transitionDuration(x.transitionDuration)
            (dom);

        if(x.hasOwnProperty(x.yAggregation))
          chart.yAggregation(x.yAggregation)

        if(x.hasOwnProperty(x.positiveColorStops))
          chart.positiveColorStops(x.positiveColorStops)

        if(x.hasOwnProperty(x.negativeColorStops))
          chart.negativeColorStops(x.negativeColorStops)
          
        if(x.hasOwnProperty(x.yExtent))
          chart.yExtent(x.yExtent)

        if(x.hasOwnProperty(x.interpolationCurve))
          chart.interpolationCurve(x.interpolationCurve)
      },

      resize: function(width, height) {

        console.log(dom.offsetHeight);

        chart
          .width(dom.offsetWidth)
          .height(dom.offsetHeight);

      }

    };
  }
});