'use strict'

describe 'Controller: TasksCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  TasksCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    TasksCtrl = $controller 'TasksCtrl', {
      $scope: scope
    }

  it 'should work', ->
    expect(!!TasksCtrl).toBe true
