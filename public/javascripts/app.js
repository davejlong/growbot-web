(function() {
  var displayError, drawAverages, getContainerWidth, menu, menuToggle;

  menu = $('#navigation-menu');

  menuToggle = $('#js-mobile-menu');

  menuToggle.on('click', function(e) {
    e.preventDefault();
    return menu.slideToggle(function() {
      if (menu.is(':hidden')) {
        return menu.removeAttr('style');
      }
    });
  });

  displayError = function() {
    var error, text;
    error = document.createElement('div');
    error.classList.add('error');
    text = document.createElement('span');
    text.innerText = 'An error has occurred. Please try again later.';
    error.appendChild(text);
    return document.querySelector('.message-center').appendChild(error);
  };

  drawAverages = function(rawData) {
    var averageLevels, data, totalLevels;
    data = rawData;
    totalLevels = data.reduce((function(p, c) {
      p.moisture += c.moisture;
      p.light += c.light;
      return p;
    }), {
      moisture: 0,
      light: 0
    });
    averageLevels = {
      moisture: Math.floor(totalLevels.moisture / data.length),
      light: Math.floor(totalLevels.light / data.length)
    };
    d3.select('#moistureWidget .number').text(averageLevels.moisture);
    return d3.select('#lightWidget .number').text(averageLevels.light);
  };

  getContainerWidth = function(container) {
    return $(container).innerWidth();
  };

  d3.json('/data.json').get(function(error, data) {
    var chart, colorScale, h, lightLine, m, max, min, moistureLine, scales, w, width, xAxis, yAxis;
    data = data.map(function(d) {
      d.time = new Date(d.time);
      d.x = d.time;
      return d;
    });
    min = {
      time: d3.min(data, function(d) {
        return d.time;
      }),
      light: d3.min(data, function(d) {
        return d.light;
      }),
      moisture: d3.min(data, function(d) {
        return d.moisture;
      })
    };
    max = {
      time: d3.max(data, function(d) {
        return d.time;
      }),
      light: d3.max(data, function(d) {
        return d.light;
      }),
      moisture: d3.max(data, function(d) {
        return d.moisture;
      })
    };
    drawAverages(data);
    width = getContainerWidth('#lineChart');
    m = [10, 25, 0, 40];
    w = width - m[1] - m[3];
    h = 300 - m[0] - m[2];
    scales = {
      x: d3.time.scale().domain([min.time, max.time]).range([0, w]),
      y: d3.scale.linear().range([0, h])
    };
    if (max.light > max.moisture) {
      scales.y.domain([max.light, 0]);
    } else {
      scales.y.domain([max.moisture, 0]);
    }
    chart = d3.select('#lineChart').append('svg').attr('width', w + m[1] + m[3]).attr('height', h + m[0] + m[1]).append('g').attr('transform', "translate(" + m[3] + ", " + m[0] + ")");
    xAxis = d3.svg.axis().scale(scales.x);
    yAxis = d3.svg.axis().scale(scales.y).orient('left');
    chart.append('g').attr('class', 'x axis').attr('transform', "translate(0, " + h + ")").call(xAxis);
    chart.append('g').attr('class', 'y axis').attr('transform', 'translate(0, 0)').call(yAxis);
    moistureLine = d3.svg.line().x(function(d) {
      return scales.x(d.time);
    }).y(function(d) {
      return scales.y(d.moisture);
    });
    lightLine = d3.svg.line().x(function(d) {
      return scales.x(d.time);
    }).y(function(d) {
      return scales.y(d.light);
    });
    colorScale = d3.scale.category10();
    chart.append('path').attr('d', moistureLine(data)).style('stroke', colorScale(0));
    return chart.append('path').attr('d', lightLine(data)).style('stroke', colorScale(1));
  });

}).call(this);
