'use strict'

angular.module('frontendApp')
  .service 'Authentication', ($http, Session, $q) ->
    Authentication = {}

    SERVER_URL = "https://#{location.hostname}:8080"

    Authentication.login = (credentials) ->
      return $http
        .post(SERVER_URL + "/login", credentials)
        .then (res) ->
          Session.create(res.data.id, res.data.name, 'admin')
          return res.data

    Authentication.isAuthenticated = () ->
      deferred = $q.defer()
      if !!Session.id
        deferred.resolve()
      else
        $http.get(SERVER_URL + "/current_user")
          .success (response) ->
            if response.id
              Session.create(response.id, response.name, 'admin')
              deferred.resolve()
            else
              deferred.reject()
          .error (response) ->
            deferred.reject()
      return deferred.promise

    Authentication.isAuthorized = (authorizedRoles) ->
      if !angular.isArray(authorizedRoles)
        authorizedRoles = [authorizedRoles]
      deferred = $q.defer()
      Authentication.isAuthenticated().then(
        (success) ->
          if authorizedRoles.indexOf(Session.userRole) != -1
            deferred.resolve()
          else
            deferred.reject()
        (failure) ->
          deferred.reject()
      )
      return deferred.promise

    return Authentication
