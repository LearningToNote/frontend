'use strict'

angular.module('frontendApp')
  .controller 'AddTypeModalCtrl', ($scope, args, Middleware) ->

    $scope.type = {}
    $scope.isRelation = args.relation
    $scope.baseTypes = []
    $scope.groups = []
    $scope.selectedBase = undefined
    $scope.saving = false

    for baseType in args.baseTypes
        if baseType.groupId == baseType.code
            $scope.groups.push baseType
        else
            $scope.baseTypes.push baseType

    $scope.save = () ->
        return if not $scope.selectedBase or not $scope.type.label
        $scope.saving = true
        $scope.type.type_id = $scope.selectedBase.id
        Middleware.put(
            "/task_types/-1"
            {"type": $scope.type, "relation": args.relation, "task": args.task}
        ).then(
            (success) ->
                $scope.$close()
            (error) ->
                $scope.$close()
        )

    return
