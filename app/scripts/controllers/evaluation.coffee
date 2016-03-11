'use strict'

angular.module('frontendApp')
  .controller 'EvaluationCtrl', ($scope, $http) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.tasks = []
    $scope.documents = []
    $scope.users = []

    $scope.user1 = undefined
    $scope.user2 = undefined
    $scope.document = undefined
    $scope.task_id = undefined

    $scope.results = undefined
    $scope.sum = undefined
    $scope.wrongType = undefined
    $scope.wrongTypeSum = undefined

    $http.get(SERVER_URL + "/tasks")
        .then (response) ->
            $scope.tasks = response.data

    $http.get(SERVER_URL + "/users")
        .then (response) ->
            $scope.users = response.data

    $scope.getDocuments = () ->
        $http.get(SERVER_URL + "/tasks/" + $scope.task_id)
            .then (response) ->
                $scope.documents = response.data.documents

    $scope.evaluate = () ->
        $scope.results = undefined
        $http(
            url: SERVER_URL + "/evaluate"
            data:
                user1: $scope.user1.id
                user2: $scope.user2.id
                document_id: $scope.document.document_id
            method: "POST"
        )
            .then (response) ->
                $scope.results = response.data
                $scope.sum = $scope.results['matches'] +
                    $scope.results['left-aligns'] + $scope.results['right-aligns'] +
                    $scope.results['overlaps'] + $scope.results['misses']
                $scope.wrongType = $scope.results['wrong-type']
                $scope.wrongTypeSum = ($scope.wrongType['matches'] or 0) +
                    ($scope.wrongType['right-aligns'] or 0) +
                    ($scope.wrongType['left-aligns'] or 0) +
                    ($scope.wrongType['overlaps'] or 0)

    $scope.percentOfWhole = (value) ->
        return (100.0 / $scope.sum * value).toFixed(2)

    return
