'use strict'

angular.module('frontendApp')
  .controller 'UserDetailsCtrl', ($scope, $http, $routeParams, Popup) ->

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
          Popup.show("Error: #{error.data} (#{error.status})", 'danger', 10000)
          $scope.loading = false
      )

    $scope.refreshUser()

    return
