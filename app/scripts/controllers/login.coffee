'use strict'

angular.module('frontendApp')
  .controller 'LoginCtrl', ($scope, $rootScope, Authentication, AUTH_EVENTS, $location) ->

    $scope.credentials =
      username: ''
      password: ''

    $scope.loginWith = (credentials) ->
      Authentication.login(credentials).then(
        (success) ->
          $rootScope.$broadcast AUTH_EVENTS.loginSuccess
          $location.url("/")
        (error) ->
          $rootScope.$broadcast AUTH_EVENTS.loginFailed, error
      )

    return
