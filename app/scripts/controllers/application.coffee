'use strict'

angular.module('frontendApp')
  .controller 'ApplicationCtrl', ($scope, $rootScope, USER_ROLES, AUTH_EVENTS, Authentication, Session, $location) ->

    $scope.session = Session
    $scope.userRoles = USER_ROLES
    $scope.isAuthorized = Authentication.isAuthorized

    $scope.alerts = []

    $rootScope.$on AUTH_EVENTS.loginFailed, (event, error) ->
        $scope.alert("Error: #{error.data} (#{error.status})", "danger")

    $rootScope.$on AUTH_EVENTS.loginSuccess, (event) ->
        $scope.alerts = []
        $scope.alert("Welcome, #{$scope.session.name}!", "success")

    $scope.alert = (message, level) ->
        $scope.alerts.push {type: level, msg: message}

    $scope.closeAlert = (index) ->
        $scope.alerts.splice(index, 1)

    $scope.clearAlerts = () ->
        $scope.alerts = []

    $scope.logout = () ->
        $scope.alerts = []
        Authentication.logout()
        $location.url("/login")

    return
