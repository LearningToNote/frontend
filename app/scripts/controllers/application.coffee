'use strict'

angular.module('frontendApp')
  .controller 'ApplicationCtrl', ($scope, $rootScope, USER_ROLES, AUTH_EVENTS, Authentication, Session, $location, Popup) ->

    $scope.session = Session
    $scope.userRoles = USER_ROLES
    $scope.isAuthorized = Authentication.isAuthorized

    $scope.popup = Popup

    $rootScope.$on AUTH_EVENTS.loginFailed, (event, error) ->
        Popup.show("Error: #{error.data} (#{error.status})", "danger", 10000)

    $rootScope.$on AUTH_EVENTS.loginSuccess, (event) ->
        Popup.show("Welcome, #{$scope.session.name}!", "success", 5000)

    $scope.logout = () ->
        Authentication.logout()
        $location.url("/login")

    $scope.isSelected = (menuItem) ->
        if $location.url() == menuItem
            return "selected"
        return undefined

    return
