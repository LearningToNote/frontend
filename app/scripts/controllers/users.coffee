'use strict'

angular.module('frontendApp')
  .controller 'UsersCtrl', ($scope, Middleware) ->

    $scope.users = []

    Middleware.get("/users")
        .then (response) ->
            $scope.users = response.data

    return
