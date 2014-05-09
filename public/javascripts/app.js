(function() {
  var displayError, drawAverages, drawLine, getContainerWidth, menu, menuToggle;

  menu = $('#navigation-menu');

  menuToggle = $('#js-mobile-menu');

  alert('Hello');

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
    var averageLevels, data, hourAgo, totalLevels;
    hourAgo = new Date();
    hourAgo.setHours(hourAgo.getHours() - 1);
    data = rawData.filter(function(d) {
      return d.time >= hourAgo;
    });
    if (!data.length) {
      return;
    }
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

  drawLine = function(data, container, xKey, yKey, scales) {
    var chart, h, line, m, w, width, xAxis, yAxis;
    if (xKey == null) {
      xKey = 'x';
    }
    if (yKey == null) {
      yKey = 'y';
    }
    width = getContainerWidth(container);
    m = [15, 80, 15, 80];
    w = width - m[1] - m[3];
    h = 400 - m[0] - m[2];
    chart = d3.select(container).append('svg').attr('width', w + m[1] + m[3]).attr('height', h + m[0] + m[1]).append('g').attr('transform', "translate(" + m[3] + ", " + m[0] + ")");
    scales.x.range([0, w]);
    scales.y.range([0, h]);
    xAxis = d3.svg.axis().scale(scales.x);
    yAxis = d3.svg.axis().scale(scales.y).orient('left');
    chart.append('g').attr('class', 'x axis').attr('transform', "translate(0, " + h + ")").call(xAxis);
    chart.append('g').attr('class', 'y axis').attr('transform', "translate(0, 0)").call(yAxis);
    line = d3.svg.line().x(function(d) {
      return scales.x(d[xKey]);
    }).y(function(d) {
      return scales.y(d[yKey]);
    });
    return chart.append('path').attr('d', line(data));
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
    m = [15, 80, 15, 80];
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
    console.log(colorScale);
    chart.append('path').attr('d', moistureLine(data)).style('stroke', colorScale(0));
    return chart.append('path').attr('d', lightLine(data)).style('stroke', colorScale(1));
  });

}).call(this);
