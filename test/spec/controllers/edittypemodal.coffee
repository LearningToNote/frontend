'use strict'

describe 'Controller: EditTypeModalCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  EditTypeModalCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    EditTypeModalCtrl = $controller 'EditTypeModalCtrl', {
      $scope: scope,
      args:
        type: {"name": "", "code": "", "label": "", "group": ""}
        baseTypes: []
    }

  it 'should work', ->
    expect(!!EditTypeModalCtrl).toBe true
