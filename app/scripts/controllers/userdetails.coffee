'use strict'

angular.module('frontendApp')
  .controller 'UserDetailsCtrl', ($scope, $http, $routeParams, $window) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.user = undefined
    $scope.documents = undefined
    $scope.files = []

    $scope.pubmedId = undefined

    userId = $routeParams.id

    $scope.refreshUser = () ->
      $http.get(SERVER_URL + "/users/" + userId)
        .then (response) ->
          $scope.user = response.data
          if not $scope.user.image
            $scope.user.image = "images/user.png"

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
        url: SERVER_URL + '/user_documents/' + doc.id
      $http(req).then () ->
        $scope.refreshUserDocuments()

    $scope.predictDocument = (doc) ->
      req =
        method: 'POST'
        url: SERVER_URL + '/predict'
        headers:
          'Content-Type': 'application/json'
        data:
          'user_id': doc['user_id']
          'document_id': doc['document_id']
      $http(req).then () ->
        $scope.refreshUserDocuments()

    uploadDocument = (name, content) ->
      req =
        method: 'POST'
        url: SERVER_URL + '/import'
        headers:
          'Content-Type': 'application/json'
        data:
          'document_id': name
          'text': content
          'visibility': 1
      $http(req).then () ->
        $scope.refreshUserDocuments()

    $scope.upload = () ->
      for file in $scope.files
        uploadDocument(file.name, file.body)
      $scope.files = []

    $scope.uploadFromPubmed = () ->
      $http.get(SERVER_URL + '/pubmed/' + $scope.pubmedId).then (response) ->
        uploadDocument('pubmed_' + $scope.pubmedId, response.data)
        $scope.pubmedId = undefined

    $scope.refreshUser()
    $scope.refreshUserDocuments()

    return
