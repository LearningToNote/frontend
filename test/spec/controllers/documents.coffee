'use strict'

describe 'Controller: DocumentsCtrl', ->

  # load the controller's module
  beforeEach module 'frontendApp'

  DocumentsCtrl = {}

  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DocumentsCtrl = $controller 'DocumentsCtrl', {
      $scope: scope
    }

  it 'should work', ->
    expect(!!DocumentsCtrl).toBe true
