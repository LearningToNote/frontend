'use strict'

angular.module('frontendApp')
  .controller 'TypesCtrl', ($scope) ->

    $scope.types = [
      "code": "test1", "name": "test type 1", "group_id": "001", "group": "Test Type Group"
      "code": "test2", "name": "test type 2", "group_id": "001", "group": "Test Type Group"
    ]

    return
