// Generated by CoffeeScript 1.7.1
(function() {
  var DebtGraph;

  DebtGraph = (function() {
    function DebtGraph(id, size, lenders, names) {
      var amountExtent, chargeScale, colorScale, radiusRange, radiusScale;
      this.size = size;
      this.lenders = lenders;
      this.names = names;
      this.svg = d3.select(id).append('svg').attr('width', this.size.width).attr('height', this.size.height).append('g');
      amountExtent = d3.extent(this.lenders, function(d) {
        return d.amount;
      });
      radiusRange = [50, 60];
      radiusScale = d3.scale.pow().exponent(0.5).domain(amountExtent).range(radiusRange);
      colorScale = d3.scale.linear().domain(amountExtent).range(['#6fb441', '#6fb441']);
      chargeScale = d3.scale.pow().exponent(1.5).domain(amountExtent).range([-220, -240]);
      this.lenders.forEach(function(d) {
        return d.charge = chargeScale(d.amount);
      });
      this.gs = this.svg.append('g').selectAll('g').data(this.lenders).enter().append('g');
      this.gs.append('circle').attr('cx', 0).attr('cy', 0).attr('r', function(d) {
        return radiusScale(d.amount);
      }).attr('fill', function(d) {
        return colorScale(d.amount);
      }).attr('stroke', function(d) {
        return d3.rgb(colorScale(d.amount)).darker();
      }).attr('stroke-width', 2);
      this.gs.append('text').attr('text-anchor', 'middle').text(function(d) {
        return d.name;
      }).attr('dy', '0.35em').attr('fill', d3.rgb('#6fb441').darker(2));
      this.gs.attr('data-tooltip', '').classed('has-tip tip-right', true).attr('title', function(d) {
        names = window.debtApp.names;
        return "<strong>" + d.name + "</strong>\n<hr style=\"margin:0.3em 0.05em\" />\n￥" + d.amount + " <br/>\nfrom " + names.hometown[d.hometown] + " <br/>";
      });
      this.gs.on('mouseover', function() {
        return d3.select(this).select('circle').transition().attr('stroke', '#000');
      }).on('mouseout', function() {
        return d3.select(this).select('circle').transition().attr('stroke', 'green');
      });
    }

    DebtGraph.prototype.show = function(group) {
      this.svg.selectAll('.debt-group-title').transition().duration(800).style('opacity', 0).remove();
      switch (group) {
        case 'all':
          return this.showAll();
        case 'status':
          return this.showStatus();
        default:
          return this.showBy(group);
      }
    };

    DebtGraph.prototype.showAll = function() {
      var _ref;
      if ((_ref = this.force) != null) {
        _ref.stop();
      }
      return this.force = d3.layout.force().gravity(0.08).charge(function(d) {
        return d.charge;
      }).nodes(this.lenders).size([this.size.width, this.size.height]).on('tick', (function(_this) {
        return function(e) {
          return _this.gs.attr('transform', function(d) {
            return "translate(" + d.x + "," + d.y + ")";
          });
        };
      })(this)).start();
    };

    DebtGraph.prototype.showStatus = function() {
      var groupFn, groups, names;
      groupFn = function(lender) {
        if (lender.returned) {
          return 'returned';
        } else if (lender.paid) {
          return 'not-returned';
        } else {
          return 'not-paid';
        }
      };
      groups = ['not-paid', 'not-returned', 'returned'];
      names = window.debtApp.names.status;
      return this.groupBy(groups, names, groupFn);
    };

    DebtGraph.prototype.showBy = function(key) {
      var groupFn, groups, i, names;
      groupFn = function(lender) {
        return lender[key];
      };
      names = window.debtApp.names[key];
      groups = _.uniq((function() {
        var _i, _len, _ref, _results;
        _ref = this.lenders;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          _results.push(i[key]);
        }
        return _results;
      }).call(this));
      return this.groupBy(groups, names, groupFn);
    };

    DebtGraph.prototype.groupBy = function(groups, names, groupFn, maxCol) {
      var col, cols, grid, gridH, gridW, grids, group, numRow, row, _i, _j, _len, _ref;
      if (maxCol == null) {
        maxCol = 4;
      }
      numRow = Math.ceil(groups.length / maxCol);
      gridH = this.size.height / numRow;
      grids = {};
      for (row = _i = 0; 0 <= numRow ? _i < numRow : _i > numRow; row = 0 <= numRow ? ++_i : --_i) {
        cols = groups.slice(row * maxCol, (row + 1) * maxCol);
        gridW = this.size.width / cols.length;
        for (col = _j = 0, _len = cols.length; _j < _len; col = ++_j) {
          group = cols[col];
          grid = {
            x: gridW * col,
            y: gridH * row
          };
          grids[group] = {
            base: {
              x: grid.x,
              y: grid.y
            },
            header: {
              x: grid.x + gridW / 2,
              y: grid.y + gridH / 4
            },
            center: {
              x: grid.x + gridW / 2,
              y: grid.y + gridH / 2
            }
          };
          this.svg.append('text').classed('debt-group-title', true).text(names[group]).attr('text-anchor', 'middle').attr('font-family', '"微软雅黑"').attr('x', grids[group].header.x).attr('y', -100).transition().duration(800).attr('y', grids[group].header.y);
        }
      }
      this.lenders.forEach((function(_this) {
        return function(lender) {
          group = groupFn(lender);
          lender.group = group;
          return lender.target = grids[group].center;
        };
      })(this));
      if ((_ref = this.force) != null) {
        _ref.stop();
      }
      return this.force = d3.layout.force().gravity(0.01).charge(function(d) {
        return d.charge;
      }).nodes(this.lenders).size([this.size.width, this.size.height]).on('tick', (function(_this) {
        return function(e) {
          return _this.gs.attr('transform', function(d) {
            d.x += (d.target.x - d.x) * e.alpha * 0.04;
            d.y += (d.target.y - d.y) * e.alpha * 0.04;
            return "translate(" + d.x + "," + d.y + ")";
          });
        };
      })(this)).start();
    };

    return DebtGraph;

  })();

  window.DebtGraph = DebtGraph;

}).call(this);
