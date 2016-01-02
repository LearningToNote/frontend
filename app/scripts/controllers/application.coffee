'use strict'

angular.module('frontendApp')
  .controller 'ApplicationCtrl', ($scope, USER_ROLES, Authentication, Session, $location) ->

    $scope.session = Session
    $scope.userRoles = USER_ROLES
    $scope.isAuthorized = Authentication.isAuthorized

    $scope.logout = () ->
      Authentication.logout()
      $location.url("/login")

    return
