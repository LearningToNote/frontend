'use strict'

describe 'Controller: UserDetailsCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  UserDetailsCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    UserDetailsCtrl = $controller 'UserDetailsCtrl', {
      # place here mocked dependencies
    }

  it 'should work', ->
    expect(!!UserDetailsCtrl).toBe true
