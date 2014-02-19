// Generated by CoffeeScript 1.6.3
(function() {
  angular.module('debtApp.ctrls', []).controller('DebtGraphCtrl', function($scope) {
    var graph, lenders, names;
    lenders = window.debtApp.lenders;
    names = window.debtApp.names;
    graph = new DebtGraph('#debt-graph', {
      width: 850,
      height: 550
    }, lenders, names);
    $scope.debtGroup = 'all';
    return $scope.$watch('debtGroup', function(group, prevGroup) {
      return graph.show(group);
    });
  });

  angular.module('debtApp', ['debtApp.ctrls']);

  $(function() {
    angular.bootstrap(document, ['debtApp']);
    return $('#debtGroup a').click(function() {
      return false;
    });
  });

}).call(this);
