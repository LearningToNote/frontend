'use strict'

angular.module('frontendApp')
  .controller 'DocumentsCtrl', ($scope, $http) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.tasks = []
    $scope.expandedTask = undefined
    $scope.loading = false
    $scope.documents = []
    $scope.expandedDocument = undefined
    $scope.loadingDocument = false
    $scope.userDocuments = []

    $scope.expandTask = (task) ->
      $scope.documents = []
      $scope.expandedTask = task
      getDetailsFor(task)

    $scope.expandDocument = (doc) ->
      $scope.expandedDocument = doc
      getDocumentDetailsFor(doc)

    $scope.deleteUserDocument = (userDocument) ->
      req =
        method: 'DELETE'
        url: SERVER_URL + '/user_documents/' + userDocument.id
      $http(req).then(
        (success) ->
          getDocumentDetailsFor($scope.expandedDocument)
          updateUserCountFor($scope.expandedDocument)
          $scope.$parent.alert("Document successfully deleted.", 'success')
        (error) ->
          $scope.$parent.alert("Error: #{error.data} (#{error.status})", 'danger')
      )

    $scope.generateTextAELinkFor = (doc) ->
      landingURL = "/dist/textae/textae.html?mode=edit&hana-document=#{doc.document_id}"
      return SERVER_URL + landingURL

    $scope.deleteDocument = (doc) ->
      req =
        method: 'DELETE'
        url: SERVER_URL + '/documents/' + doc.document_id
      $http(req).then(
        (success) ->
          getDetailsFor($scope.expandedTask)
          $scope.$parent.alert("Document successfully deleted.", 'success')
        (error) ->
          $scope.$parent.alert("Error: #{error.data} (#{error.status})", 'danger')
      )

    getTasks = () ->
      $scope.loading = true
      $http.get(SERVER_URL + "/tasks").then(
        (response) ->
          $scope.tasks = response.data
          $scope.loading = false
        (error) ->
          $scope.$parent.alert("An error occured while fetching the tasks.", "danger")
          $scope.loading = false
      )

    getDetailsFor = (task) ->
      $scope.loading = true
      $http.get(SERVER_URL + "/tasks/" + task.task_id).then(
        (response) ->
          $scope.documents = response.data.documents
          $scope.loading = false
        (error) ->
          $scope.$parent.alert("An error occured while fetching task details: \"#{error.data}\"", "danger")
          $scope.loading = false
      )

    getDocumentDetailsFor = (doc) ->
      $scope.loadingDocument = true
      $http.get(SERVER_URL + "/user_documents_for/" + doc.document_id).then(
        (response) ->
          $scope.userDocuments = response.data
          $scope.loadingDocument = false
        (error) ->
          $scope.$parent.alert("An error occured while fetching document details: \"#{error.data}\"", "danger")
          $scope.loadingDocument = false
      )

    updateUserCountFor = (doc) ->
      for element in $scope.documents
        if element.document_id == doc.document_id
          element.user_document_count = element.user_document_count - 1
          break

    getTasks()
    return
