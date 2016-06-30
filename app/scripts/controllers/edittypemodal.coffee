'use strict'

angular.module('frontendApp')
  .controller 'EditTypeModalCtrl', ($scope, args, Middleware) ->

    $scope.type = args.type
    $scope.task = args.task
    $scope.baseTypes = []
    $scope.groups = []
    $scope.selectedBase = undefined
    $scope.saving = false

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
        $scope.saving = true
        $scope.type.type_id = $scope.selectedBase.id
        Middleware.put(
            "/task_types/" + $scope.type.id
            {"type": $scope.type}
        ).then(
            (success) ->
                $scope.$close()
            (error) ->
                $scope.$close()
        )

    return
