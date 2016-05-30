'use strict'

angular.module('frontendApp')
  .controller 'TypesCtrl', ($scope, $routeParams, $http, $uibModal) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.task = $routeParams.task_id

    $scope.baseTypes = []

    $scope.entityTypes = []
    $scope.entityTypesLoading = true

    $scope.relationTypes = []
    $scope.relationTypesLoading = true

    $http.get(SERVER_URL + "/base_types").then(
        (response) ->
            $scope.baseTypes = response.data

            $http.get(SERVER_URL + "/tasks/#{$scope.task}/entity_types").then(
                (response) ->
                    $scope.entityTypes = response.data
                    $scope.entityTypesLoading = false
                (error) ->
                    $scope.$parent.alert("An error occured while fetching the entity types.", "danger")
                    $scope.entityTypesLoading = false
            )

            $http.get(SERVER_URL + "/tasks/#{$scope.task}/relation_types").then(
                (response) ->
                    $scope.relationTypes = response.data
                    $scope.relationTypesLoading = false
                (error) ->
                    $scope.$parent.alert("An error occured while fetching the relation types.", "danger")
                    $scope.relationTypesLoading = false
            )
        (error) ->
            $scope.$parent.alert("An error occured while fetching the base types.", "danger")
    )

    $scope.editEntityType = (type) ->
        $uibModal.open
            templateUrl: 'views/_edit_type.html'
            controller: 'EditTypeModalCtrl'
            backdrop: true
            resolve: args: () ->
                type: type
                task: $scope.task
                baseTypes: $scope.baseTypes

    $scope.addEntityType = () ->
        $uibModal.open
            templateUrl: 'views/_edit_type.html'
            controller: 'AddTypeModalCtrl'
            backdrop: true
            resolve: args: () ->
                task: $scope.task
                baseTypes: $scope.baseTypes
                relation: false

    deleteFromArray = (item, array) ->
        index = array.indexOf item
        if index > -1
            array.splice(index, 1)

    $scope.deleteType = (type) ->
        if confirm "Do you want to remove '#{type.label}'?"
            $http.delete(SERVER_URL + "/task_types/" + type.id).then(
                (success) ->
                    deleteFromArray(type, $scope.entityTypes)
                    deleteFromArray(type, $scope.relationTypes)
                    $scope.$parent.alert("Deleted '#{type.label}'", "success")
                (error) ->
                    $scope.$parent.alert("An error occured.", "danger")
            )

    return
