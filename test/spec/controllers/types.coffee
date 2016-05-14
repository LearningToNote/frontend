'use strict'

describe 'Controller: TypesCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  TypesCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    TypesCtrl = $controller 'TypesCtrl', {
      $scope: scope,
    }

  it 'should work', ->
    expect(!!TypesCtrl).toBe true
