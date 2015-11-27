'use strict'

angular.module('frontendApp')
  .controller 'UsersCtrl', ($scope, $http) ->

    $scope.users = []

    $http.get("https://#{location.hostname}:8080/users")
        .then (response) ->
            $scope.users = response.data

    return
