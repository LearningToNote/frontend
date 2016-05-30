'use strict'

angular.module('frontendApp')
  .controller 'AddTypeModalCtrl', ($scope, args, $http) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.type = {}
    $scope.task = args.task
    $scope.baseTypes = []
    $scope.groups = []
    $scope.selectedBase = undefined

    for baseType in args.baseTypes
        if baseType.groupId == baseType.code
            $scope.groups.push baseType
        else
            $scope.baseTypes.push baseType

    $scope.save = () ->

        $http.put(
            SERVER_URL + "/task_types/0"
            {"type": $scope.type}
        ).then(
            (success) ->
                $scope.$close()
            (error) ->
                $scope.$close()
                $scope.$parent.alert("The new type could not be saved", "danger")
        )

    return
