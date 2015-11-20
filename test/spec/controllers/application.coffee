'use strict'

describe 'Controller: ApplicationCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  ApplicationCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ApplicationCtrl = $controller 'ApplicationCtrl', {
      $scope: scope
    }

  it 'should work', ->
    expect(!!ApplicationCtrl).toBe true
