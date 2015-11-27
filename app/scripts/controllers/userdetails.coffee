'use strict'

angular.module('frontendApp')
  .controller 'UserDetailsCtrl', ($scope, $http, $routeParams, $window) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.user = undefined
    $scope.documents = undefined

    userId = $routeParams.id

    $http.get(SERVER_URL + "/users/" + userId)
      .then (response) ->
        $scope.user = response.data

    $http.get(SERVER_URL + "/user_documents/" + userId)
      .then (response) ->
        $scope.documents = response.data


    $scope.showDocument = (document) ->
      landingUrl = "/dist/textae/textae.html?mode=edit&hana-document=#{document.id}"
      $window.location.href = SERVER_URL + landingUrl

    return
