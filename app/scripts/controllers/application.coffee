'use strict'

angular.module('frontendApp')
  .controller 'ApplicationCtrl', ($scope, USER_ROLES, Authentication, Session) ->

    $scope.session = Session
    $scope.userRoles = USER_ROLES
    $scope.isAuthorized = Authentication.isAuthorized

    return
