'use strict'

angular.module('frontendApp')
  .service 'Session', ->
    Session = {}

    Session.create = (id, name, role) ->
      this.id = id
      this.name = name
      this.role = role

    Session.destroy = ->
      this.id = null
      this.name = null
      this.role = null

    return Session
