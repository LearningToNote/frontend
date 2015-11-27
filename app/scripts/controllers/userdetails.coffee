'use strict'

angular.module('frontendApp')
  .controller 'UserDetailsCtrl', ($scope, $http, $routeParams) ->

    $scope.user = undefined
    $scope.documents = undefined

    userId = $routeParams.id

    $http.get("https://#{location.hostname}:8080/users/" + userId)
        .then (response) ->
            $scope.user = response.data

    $http.get("https://#{location.hostname}:8080/user_documents/" + userId)
        .then (response) ->
            $scope.documents = response.data

    return
