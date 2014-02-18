
# controllers
angular.module('debtApp.ctrls', []).controller 'DebtGraphCtrl', ($scope)->
  lenders = window.debtApp.lenders
  names = window.debtApp.names

  graph = new DebtGraph '#debt-graph', {width:850,height:550}, lenders, names

  $scope.debtGroup = 'all'
  $scope.$watch 'debtGroup', (group, prevGroup)->
    graph.show group

# app module
angular.module('debtApp', ['debtApp.ctrls'])

# bootstrap everything
$ ->
  angular.bootstrap(document, ['debtApp'])
  
  # 禁止页面跳转行为
  $('#debtGroup a').click -> return false

