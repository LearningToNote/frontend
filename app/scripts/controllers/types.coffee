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


    return
