'use strict'

angular.module('frontendApp')
.controller 'TypesCtrl', ($scope, $routeParams, Middleware, $uibModal, Popup) ->

  $scope.task = $routeParams.task_id

  $scope.baseTypes = []

  $scope.entityTypes = []
  $scope.entityTypesLoading = true

  $scope.relationTypes = []
  $scope.relationTypesLoading = true

  init = () ->
    Middleware.get("/base_types").then(
      (response) ->
        $scope.baseTypes = response.data

        Middleware.get("/tasks/#{$scope.task}/entity_types").then(
          (response) ->
            $scope.entityTypes = response.data
            $scope.entityTypesLoading = false
          (error) ->
            Popup.show("An error occured while fetching the entity types.", "danger", 10000)
            $scope.entityTypesLoading = false
        )

        Middleware.get("/tasks/#{$scope.task}/relation_types").then(
          (response) ->
            $scope.relationTypes = response.data
            $scope.relationTypesLoading = false
          (error) ->
            Popup.show("An error occured while fetching the relation types.", "danger", 10000)
            $scope.relationTypesLoading = false
        )
      (error) ->
        Popup.show("An error occured while fetching the base types.", "danger", 10000)
    )

  $scope.editType = (type) ->
    $uibModal.open
      templateUrl: 'views/_edit_type.html'
      controller: 'EditTypeModalCtrl'
      backdrop: true
      resolve:
        args: () ->
          type: type
          task: $scope.task
          baseTypes: $scope.baseTypes
    .result.then () ->
      init()

  $scope.addType = (relation) ->
    $uibModal.open
      templateUrl: 'views/_edit_type.html'
      controller: 'AddTypeModalCtrl'
      backdrop: true
      resolve:
        args: () ->
          task: $scope.task
          baseTypes: $scope.baseTypes
          relation: relation
    .result.then () ->
      init()

  deleteFromArray = (item, array) ->
    index = array.indexOf item
    if index > -1
      array.splice(index, 1)

  $scope.deleteType = (type) ->
    if confirm "Do you want to remove '#{type.label}'?"
      Middleware.delete("/task_types/" + type.id).then(
        (success) ->
          deleteFromArray(type, $scope.entityTypes)
          deleteFromArray(type, $scope.relationTypes)
          Popup.show("Deleted '#{type.label}'", "success", 5000)
        (error) ->
          Popup.show("An error occured.", "danger", 10000)
      )

  init()
  return
