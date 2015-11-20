'use strict'

angular.module('frontendApp')
  .controller 'ApplicationCtrl', ($scope, USER_ROLES, Authentication) ->

    $scope.currentUser = null
    $scope.userRoles = USER_ROLES
    $scope.isAuthorized = Authentication.isAuthorized

    $scope.setCurrentUser = (user) ->
      $scope.currentUser = user

    return
