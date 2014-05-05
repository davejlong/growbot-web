menu = $('#navigation-menu')
menuToggle = $('#js-mobile-menu')

menuToggle.on 'click', (e) ->
  e.preventDefault()
  menu.slideToggle () ->
    menu.removeAttr 'style' if menu.is ':hidden'


displayError = () ->
  error = document.createElement 'div'
  error.classList.add 'error'

  text = document.createElement 'span'
  text.innerText = 'An error has occurred. Please try again later.'
  error.appendChild text

  document.querySelector('.message-center').appendChild error

drawAverages = (rawData) ->
  # Reduce down the data to build averages
  hourAgo = new Date()
  hourAgo.setHours hourAgo.getHours()-1


  data = rawData.filter (d) -> d.time >= hourAgo
  return unless data.length

  totalLevels = data.reduce ((p, c) ->
    p.moisture += c.moisture
    p.light += c.light
    p
  ), { moisture: 0, light: 0 }
  averageLevels = {
    moisture: Math.floor(totalLevels.moisture / data.length)
    light: Math.floor(totalLevels.light / data.length)
  }

  d3.select('#moistureWidget .number').text averageLevels.moisture
  d3.select('#lightWidget .number').text averageLevels.light

getContainerWidth = (container) ->
  $(container).innerWidth()

drawLine = (data, container, xKey='x', yKey='y', scales) ->
  width = getContainerWidth(container)
  m = [15, 80, 15, 80] # Margins
  w = width - m[1] - m[3] # Width
  h = 400 - m[0] - m[2] # Height
  # Create the initial chart to work with
  chart = d3.select(container).append('svg')
    .attr('width', w + m[1] + m[3]).attr('height', h + m[0] + m[1])
    .append('g')
    .attr('transform', "translate(#{m[3]}, #{m[0]})")

  scales.x.range([0, w])
  scales.y.range([0, h])

  xAxis = d3.svg.axis().scale(scales.x)
  yAxis = d3.svg.axis().scale(scales.y).orient('left')
  chart.append('g').attr('class', 'x axis')
    .attr('transform', "translate(0, #{h})")
    .call(xAxis)
  chart.append('g').attr('class', 'y axis')
    .attr('transform', "translate(0, 0)")
    .call(yAxis)

  line = d3.svg.line()
    .x((d) -> scales.x(d[xKey]))
    .y((d) -> scales.y(d[yKey]))
    # .interpolate('cardinal')

  chart.append('path').attr('d', line(data))


d3.json('/data.json')
  .get (error, data) ->
    data = data.map (d) ->
      d.time = new Date(d.time)
      d.x = d.time
      d
    min =
      time: d3.min data, (d) -> d.time
      light: d3.min data, (d) -> d.light
      moisture: d3.min data, (d) -> d.moisture
    max =
      time: d3.max data, (d) -> d.time
      light: d3.max data, (d) -> d.light
      moisture: d3.max data, (d) -> d.moisture

    drawAverages(data)


    width = getContainerWidth('#lineChart')
    m = [15, 80, 15, 80] # Margins
    w = width - m[1] - m[3] # Width
    h = 300 - m[0] - m[2] # Height

    scales =
      x: d3.time.scale().domain([min.time, max.time]).range([0, w])
      y: d3.scale.linear().range([0, h])
    if max.light > max.moisture
      scales.y.domain([max.light, 0])
    else
      scales.y.domain([max.moisture, 0])

    chart = d3.select('#lineChart').append('svg')
      .attr('width', w + m[1] + m[3]).attr('height', h + m[0] + m[1])
      .append('g')
      .attr('transform', "translate(#{m[3]}, #{m[0]})")

    xAxis = d3.svg.axis().scale(scales.x)
    yAxis = d3.svg.axis().scale(scales.y).orient('left')
    chart.append('g').attr('class', 'x axis')
      .attr('transform', "translate(0, #{h})")
      .call xAxis
    chart.append('g').attr('class', 'y axis')
      .attr('transform', 'translate(0, 0)')
      .call yAxis

    moistureLine = d3.svg.line()
      .x((d) -> scales.x(d.time))
      .y((d) -> scales.y(d.moisture))
    lightLine = d3.svg.line()
      .x((d) -> scales.x(d.time))
      .y((d) -> scales.y(d.light))

    colorScale = d3.scale.category10()
    console.log(colorScale)
    chart.append('path').attr('d', moistureLine(data)).style('stroke', colorScale(0))
    chart.append('path').attr('d', lightLine(data)).style('stroke', colorScale(1))
