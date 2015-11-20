'use strict'

describe 'Controller: AboutCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  AboutCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AboutCtrl = $controller 'AboutCtrl', {
      # place here mocked dependencies
    }

  it 'should work', ->
    expect(!!AboutCtrl).toBe true
