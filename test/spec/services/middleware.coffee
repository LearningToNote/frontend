'use strict'

describe 'Service: Middleware', ->

  # load the service's module
  beforeEach module 'frontendApp'

  # instantiate service
  Middleware = {}
  beforeEach inject (_Middleware_) ->
    Middleware = _Middleware_

  it 'should do something', ->
    expect(!!Middleware).toBe true
