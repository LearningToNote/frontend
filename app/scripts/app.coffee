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
    'ngFile',
    'ui.bootstrap'
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
        data:
          authorizedRoles: [USER_ROLES.admin, USER_ROLES.editor]
      .when '/documents',
        templateUrl: 'views/documents.html'
        controller: 'DocumentsCtrl'
        controllerAs: 'documents'
        css: 'styles/documents.css'
        data:
          authorizedRoles: [USER_ROLES.admin, USER_ROLES.editor]
      .when '/tasks',
        templateUrl: 'views/tasks.html'
        controller: 'TasksCtrl'
        controllerAs: 'tasks'
        css: 'styles/tasks.css'
        data:
          authorizedRoles: [USER_ROLES.admin, USER_ROLES.editor]
      .when '/types',
        templateUrl: 'views/types.html'
        controller: 'TypesCtrl'
        controllerAs: 'types'
      .otherwise
        redirectTo: '/'
  .config(['$httpProvider', ($httpProvider) ->
    $httpProvider.defaults.withCredentials = true
  ])
  .run ($rootScope, AUTH_EVENTS, Authentication, $location) ->
    $rootScope.$on '$routeChangeStart', (event, next) ->
      return if not next.data
      authorizedRoles = next.data.authorizedRoles
      Authentication.isAuthorized(authorizedRoles).then(
        (success) ->
          return
        (failure) ->
          event.preventDefault()
          Authentication.isAuthenticated().then(
            (success) ->
              $rootScope.$broadcast(AUTH_EVENTS.notAuthorized)
            (failure) ->
              $rootScope.$broadcast(AUTH_EVENTS.notAuthenticated)
              $location.url("/login")
          )
      )
