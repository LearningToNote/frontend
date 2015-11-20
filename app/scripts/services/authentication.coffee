'use strict'

angular.module('frontendApp')
  .service 'Authentication', ($http, Session, $q) ->
    Authentication = {}

    Authentication.login = (credentials) ->
      deferred = $q.defer()
      Session.create("Hugo", "Hugo", "admin")
      deferred.resolve()
      return deferred.promise
      return $http
        .post('/login', credentials)
        .then (res) ->
          Session.create(res.data.id, res.data.user.id, res.data.user.role)
          return res.data.user

    Authentication.isAuthenticated = () ->
      return !!Session.userId

    Authentication.isAuthorized = (authorizedRoles) ->
      if !angular.isArray(authorizedRoles)
        authorizedRoles = [authorizedRoles]
      return (Authentication.isAuthenticated() and
        authorizedRoles.indexOf(Session.userRole) != -1)

    return Authentication
