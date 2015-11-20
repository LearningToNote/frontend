'use strict'

describe 'Service: Authentication', ->

  # load the service's module
  beforeEach module 'frontendApp'

  # instantiate service
  Authentication = {}
  beforeEach inject (_Authentication_) ->
    Authentication = _Authentication_

  it 'should do something', ->
    expect(!!Authentication).toBe true
