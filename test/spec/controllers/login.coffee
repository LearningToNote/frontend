'use strict'

describe 'Controller: LoginCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  LoginCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    LoginCtrl = $controller 'LoginCtrl', {
      # place here mocked dependencies
    }

  it 'should work', ->
    expect(!!LoginCtrl).toBe true
