'use strict'

describe 'Service: USER_ROLES', ->

  # load the service's module
  beforeEach module 'frontendApp'

  # instantiate service
  USER_ROLES = {}
  beforeEach inject (_USER_ROLES_) ->
    USER_ROLES = _USER_ROLES_

  it 'should do something', ->
    expect(!!USER_ROLES).toBe true
