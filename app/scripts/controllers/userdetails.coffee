'use strict'

angular.module('frontendApp')
  .controller 'UserDetailsCtrl', ($scope, $http, $routeParams) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.user = undefined
    $scope.loading = false

    userId = $routeParams.id

    $scope.refreshUser = () ->
      $scope.loading = true
      $http.get(SERVER_URL + "/users/" + userId).then(
        (response) ->
          $scope.user = response.data
          if not $scope.user.image
            $scope.user.image = "images/user.png"
          $scope.loading = false
        (error) ->
          $scope.$parent.alert("Error: #{error.data} (#{error.status})", 'danger')
          $scope.loading = false
      )

    $scope.refreshUser()

    return
