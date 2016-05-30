'use strict'

describe 'Controller: AddTypeModalCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  AddTypeModalCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AddTypeModalCtrl = $controller 'AddTypeModalCtrl', {
      $scope: scope,
      args:
        task: 0
        baseTypes: []
    }

  it 'should work', ->
    expect(!!AddTypeModalCtrl).toBe true
