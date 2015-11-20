'use strict'

angular.module('frontendApp')
  .controller 'LoginCtrl', ($scope, $rootScope, Authentication, AUTH_EVENTS) ->

    $scope.credentials =
      username: 'Horst'
      password: ''

    $scope.loginWith = (credentials) ->
      Authentication.login(credentials).then(
        (user) ->
          $rootScope.$broadcast AUTH_EVENTS.loginSuccess
          $scope.$parent.setCurrentUser user
        () ->
          $rootScope.$broadcast AUTH_EVENTS.loginFailed
      )

    return
