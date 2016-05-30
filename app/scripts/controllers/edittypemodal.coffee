'use strict'

angular.module('frontendApp')
  .controller 'EditTypeModalCtrl', ($scope, args, $http) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.type = args.type
    $scope.task = args.task
    $scope.baseTypes = []
    $scope.groups = []
    $scope.selectedBase = undefined

    for baseType in args.baseTypes
        if baseType.groupId == baseType.code
            $scope.groups.push baseType
        else
            $scope.baseTypes.push baseType

        if baseType.code == $scope.type.code
            $scope.selectedBase = baseType

    $scope.isGroup = (type) ->
        return (type in $scope.groups)

    $scope.save = () ->
        $http.put(
            SERVER_URL + "/task_types/" + $scope.type.id
            {"type": $scope.type}
        ).then(
            (success) ->
                $scope.$close()
            (error) ->
                $scope.$close()
                $scope.$parent.alert("The changes could not be saved", "danger")
        )

    return
