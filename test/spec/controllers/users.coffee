'use strict'

describe 'Controller: UsersCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  UsersCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    UsersCtrl = $controller 'UsersCtrl', {
      # place here mocked dependencies
    }

  it 'should work', ->
    expect(!!UsersCtrl).toBe true
