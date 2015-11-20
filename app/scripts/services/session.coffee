'use strict'

angular.module('frontendApp')
  .service 'Session', ->
    Session = {}

    Session.create = (sessionId, userId, userRole) ->
      this.id = sessionId
      this.userId = userId
      this.userRole = userRole

    Session.destroy = ->
      this.id = null
      this.userId = null
      this.userRole = null

    return Session
