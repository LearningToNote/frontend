'use strict'

angular.module('frontendApp')
  .service 'Authentication', ($http, Session, $q) ->
    Authentication = {}

    Authentication.login = (credentials) ->
      return $http
        .post("https://#{location.hostname}:8080/login", credentials)
        .then (res) ->
          Session.create(res.data.id, res.data.name, 'admin')
          return res.data

    Authentication.isAuthenticated = () ->
      return !!Session.userId

    Authentication.isAuthorized = (authorizedRoles) ->
      if !angular.isArray(authorizedRoles)
        authorizedRoles = [authorizedRoles]
      return (Authentication.isAuthenticated() and
        authorizedRoles.indexOf(Session.userRole) != -1)

    return Authentication
