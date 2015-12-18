'use strict'

angular.module('frontendApp')
  .controller 'EvaluationCtrl', ($scope, $http) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.documents = []
    $scope.users = []

    $scope.user1 = undefined
    $scope.user2 = undefined
    $scope.documentId = undefined

    $scope.results = undefined
    $scope.sum = undefined

    $http.get(SERVER_URL + "/documents")
        .then (response) ->
            $scope.documents = response.data

    $http.get(SERVER_URL + "/users")
        .then (response) ->
            $scope.users = response.data

    $scope.evaluate = () ->
        $scope.results = undefined
        $http(
            url: SERVER_URL + "/evaluate"
            data:
                user1: $scope.user1.id
                user2: $scope.user2.id
                document_id: $scope.documentId
            method: "POST"
        )
            .then (response) ->
                $scope.results = response.data
                $scope.sum = $scope.results['matches'] + $scope.results['left-aligns'] + $scope.results['right-aligns'] +
                    $scope.results['overlaps'] + $scope.results['misses'] + $scope.results['wrong-type']

    $scope.percentOfWhole = (value) ->
        return (100.0 / $scope.sum * value).toFixed(2)

    return
