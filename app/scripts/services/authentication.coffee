'use strict'

angular.module('frontendApp')
  .service 'Authentication', (Middleware, Session, $q) ->
    Authentication = {}

    Authentication.login = (credentials) ->
      return Middleware
        .post("/login", credentials)
        .then (res) ->
          Session.create(res.data.id, res.data.name, 'admin')
          return res.data

    Authentication.logout = () ->
      Middleware.get("/logout").then () ->
        Session.destroy()

    Authentication.isAuthenticated = () ->
      deferred = $q.defer()
      if !!Session.id
        deferred.resolve()
      else
        Middleware.get("/current_user")
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
