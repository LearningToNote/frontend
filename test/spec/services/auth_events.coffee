'use strict'

describe 'Service: AUTHE_VENTS', ->

  # load the service's module
  beforeEach module 'frontendApp'

  # instantiate service
  AUTH_EVENTS = {}
  beforeEach inject (_AUTH_EVENTS_) ->
    AUTHEVENTS = _AUTH_EVENTS_

  it 'should do something', ->
    expect(!!AUTH_EVENTS).toBe true
