'use strict'

describe 'Controller: EvaluationCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  EvaluationCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    EvaluationCtrl = $controller 'EvaluationCtrl', {
      $scope: scope
    }

  it 'should work', ->
    expect(!!EvaluationCtrl).toBe true
