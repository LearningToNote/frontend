'use strict'

angular
  .module('frontendApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'routeStyles',
    'ngFile'
  ])
  .config ($routeProvider, USER_ROLES) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        controllerAs: 'main'
        data:
          authorizedRoles: [USER_ROLES.admin, USER_ROLES.editor]
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
        controllerAs: 'about'
      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
        controllerAs: 'login'
      .when '/users',
        templateUrl: 'views/users.html'
        controller: 'UsersCtrl'
        controllerAs: 'users'
        css: 'styles/users.css'
        data:
          authorizedRoles: [USER_ROLES.admin, USER_ROLES.editor]
      .when '/users/:id',
        templateUrl: 'views/userdetails.html'
        controller: 'UserDetailsCtrl'
        controllerAs: 'userDetails'
        css: 'styles/userDetails.css'
        data:
          authorizedRoles: [USER_ROLES.admin, USER_ROLES.editor]
      .when '/evaluate',
        templateUrl: 'views/evaluation.html'
        controller: 'EvaluationCtrl'
        controllerAs: 'evaluation'
        css: 'styles/evaluation.css'
      .otherwise
        redirectTo: '/'
  .config(['$httpProvider', ($httpProvider) ->
    $httpProvider.defaults.withCredentials = true
  ])
  .run ($rootScope, AUTH_EVENTS, Authentication, $location) ->
    $rootScope.$on '$routeChangeStart', (event, next) ->
      return if not next.data
      authorizedRoles = next.data.authorizedRoles
      if not Authentication.isAuthorized(authorizedRoles)
        event.preventDefault()
        if Authentication.isAuthenticated()
          $rootScope.$broadcast(AUTH_EVENTS.notAuthorized)
        else
          $rootScope.$broadcast(AUTH_EVENTS.notAuthenticated)
          $location.url("/login")
