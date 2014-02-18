
class DebtGraph
  constructor: (id, @size, @lenders, @names)->
    @svg = d3.select(id)
      .append('svg')
      .attr('width', @size.width)
      .attr('height', @size.height)
      .append('g')
    
    amountExtent = d3.extent @lenders, (d)->d.amount
    radiusRange = [50, 60]

    radiusScale = d3.scale.pow()
      .exponent(0.5)
      .domain(amountExtent)
      .range(radiusRange)
    colorScale = d3.scale.linear()
      .domain(amountExtent)
      .range(['#6fb441', '#6fb441']) # todo
    chargeScale = d3.scale.pow()
      .exponent(1.5)
      .domain(amountExtent)
      .range([-220, -240])
    @lenders.forEach (d)->
      d.charge = chargeScale(d.amount)

    @gs = @svg.append('g')
      .selectAll('g')
      .data(@lenders)
      .enter().append('g')

    @gs.append('circle')
      .attr('cx', 0)
      .attr('cy', 0)
      .attr('r', (d)->radiusScale(d.amount))
      .attr('fill', (d)->colorScale(d.amount))
      .attr('stroke', (d)->d3.rgb(colorScale(d.amount)).darker())
      .attr('stroke-width', 2)

    @gs.append('text')
      .attr('text-anchor', 'middle')
      .text((d)->d.name)
      .attr('dy', '0.35em')
      .attr('fill', d3.rgb('#6fb441').darker(2))

    @gs.attr('data-tooltip', '')
      .classed('has-tip tip-right', true)
      .attr 'title', (d)->
        names = window.debtApp.names
        """
        <strong>#{d.name}</strong>
        <hr style="margin:0.3em 0.05em" />
        ￥#{d.amount} <br/>
        @#{names.college[d.college]} <br/>
        from #{names.hometown[d.hometown]} <br/>
        """

    @gs.on 'mouseover', ->
        d3.select(this).select('circle')
          .transition()
          .attr('stroke', '#000')
      .on 'mouseout', ->
        d3.select(this).select('circle')
          .transition()
          .attr('stroke', 'green')

  show: (group)->
    @svg.selectAll('.debt-group-title')
      .transition()
      .duration(800)
      .style('opacity', 0)
      .remove()
    @['show_'+group]()

  show_all: ->
    @force?.stop()
    @force = d3.layout.force()
      .gravity(0.08)
      #.friction(0.8)
      .charge((d)->d.charge)
      .nodes(@lenders)
      .size([@size.width, @size.height])
      .on 'tick', (e)=>
        @gs.attr('transform', (d)->"translate(#{d.x},#{d.y})")
      .start()

  show_status: ->
    groupFn = (lender)->
      if lender.returned
        'returned'
      else if lender.paid
        'not-returned'
      else
        'not-paid'
    groups = ['not-paid', 'not-returned', 'returned']
    names = window.debtApp.names.status
    @groupBy groups, names, groupFn

  show_college: ->
    groupFn = (lender)->lender.college
    names = window.debtApp.names.college
    groups = Object.keys(names)
    @groupBy groups, names, groupFn

  show_hometown: ->
    groupFn = (lender)->lender.hometown
    names = window.debtApp.names.hometown
    groups = Object.keys(names)
    @groupBy groups, names, groupFn

  show_greatness: ->
    groupFn = (lender)->lender.greatness
    names = window.debtApp.names.greatness
    groups = Object.keys(names)
    @groupBy groups, names, groupFn

  groupBy: (groups, names, groupFn, maxCol = 4)->
    numRow = Math.ceil(groups.length / maxCol)
    gridH = @size.height / numRow
    grids = {}
    for row in [0...numRow]
      cols = groups.slice(row * maxCol, (row + 1) * maxCol)
      gridW = @size.width / cols.length
      for group, col in cols
        # 要注意，gridW在每个row是不一样的
        grid =
          x: gridW * col
          y: gridH * row
        grids[group] =
          base:
            x: grid.x
            y: grid.y
          header:
            x: grid.x + gridW / 2
            y: grid.y + gridH / 4
          center:
            x: grid.x + gridW / 2
            y: grid.y + gridH / 2
        @svg.append('text')
          .classed('debt-group-title', true)
          .text(names[group])
          .attr('text-anchor', 'middle')
          .attr('font-family', '"微软雅黑"')
          .attr('x', grids[group].header.x)
          .attr('y', -100)
          .transition()
          .duration(800)
          .attr('y', grids[group].header.y)

    @lenders.forEach (lender)=>
      group = groupFn(lender)
      lender.group = group
      lender.target = grids[group].center

    @force?.stop()
    @force = d3.layout.force()
      .gravity(0.01)
      #.friction(0.8)
      .charge((d)->d.charge)
      .nodes(@lenders)
      .size([@size.width, @size.height])
      .on 'tick', (e)=>
        @gs.attr 'transform', (d)->
          d.x += (d.target.x - d.x) * e.alpha * 0.04
          d.y += (d.target.y - d.y) * e.alpha * 0.04
          "translate(#{d.x},#{d.y})"
      .start()

window.DebtGraph = DebtGraph
