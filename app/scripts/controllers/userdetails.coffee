'use strict'

angular.module('frontendApp')
  .controller 'UserDetailsCtrl', ($scope, $http, $routeParams, $window) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.user = undefined
    $scope.documents = undefined
    $scope.files = []

    userId = $routeParams.id

    $scope.refreshUser = () ->
      $http.get(SERVER_URL + "/users/" + userId)
        .then (response) ->
          $scope.user = response.data

    $scope.refreshUserDocuments = () ->
      $http.get(SERVER_URL + "/user_documents/" + userId)
        .then (response) ->
          $scope.documents = response.data


    $scope.showDocument = (doc) ->
      landingUrl = "/dist/textae/textae.html?mode=edit&hana-document=#{doc.document_id}"
      $window.location.href = SERVER_URL + landingUrl

    $scope.deleteDocument = (doc) ->
      req =
        method: 'DELETE'
        url: SERVER_URL + '/documents/' + doc.document_id
      $http(req).then () ->
        $scope.refreshUserDocuments()

    $scope.upload = () ->
      for file in $scope.files
        req =
          method: 'POST'
          url: SERVER_URL + '/import'
          headers:
            'Content-Type': 'application/json'
          data:
            'document_id': file.name
            'text': file.body
            'visibility': 1
        $http(req).then () ->
          $scope.refreshUserDocuments()

    $scope.refreshUser()
    $scope.refreshUserDocuments()

    return
