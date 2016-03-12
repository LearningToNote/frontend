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
    $scope.userDocuments = undefined
    $scope.documentCount = 50

    $scope.files = []
    $scope.pubmedId = undefined

    $scope.expandTask = (task) ->
      $scope.documents = []
      if task == $scope.expandedTask
        $scope.expandedTask = undefined
      else
        $scope.expandedTask = task
        getDetailsFor(task)

    $scope.expandDocument = (doc) ->
      $scope.userDocuments = undefined
      if doc == $scope.expandedDocument
        $scope.expandedDocument = undefined
      else
        $scope.expandedDocument = doc
        getDocumentDetailsFor(doc)

    $scope.generateExportDocumentLinkFor = (doc) ->
      return SERVER_URL + '/export/' + doc.document_id

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
      landingURL = "/dist/textae/textae.html?mode=edit&hana-document=#{doc.document_id}&tid=#{$scope.expandedTask.task_id}"
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

    $scope.upload = () ->
      for file in $scope.files[$scope.expandedTask.task_id]
        uploadDocument(file.name, file.body)
      $scope.files[$scope.expandedTask.task_id] = []

    $scope.uploadFromPubmed = () ->
      $http.get(SERVER_URL + '/pubmed/' + $scope.pubmedId).then(
        (response) ->
          uploadDocument('pubmed_' + $scope.pubmedId, response.data)
          $scope.pubmedId = undefined
        (error) ->
          $scope.$parent.alert('There was a problem retrieving the document from PubMed. Is the ID correct?', 'danger')
      )

    $scope.predictDocument = (doc) ->
      req =
        method: 'POST'
        url: SERVER_URL + '/predict'
        headers:
          'Content-Type': 'application/json'
        data:
          'user_id': doc.user_id
          'document_id': doc.document_id
      $http(req).then(
        (success) ->
          $scope.$parent.alert("Predictions created.", 'success')
        (error) ->
          $scope.$parent.alert("Error: #{error.data} (#{error.status})", 'danger')
      )

    $scope.addMoreDocuments = () ->
      $scope.documentCount += 2

    $scope.toggleDocumentVisibility = (document_id, userDocument) ->
      previousValue = userDocument.visible
      userDocument.visible = !userDocument.visible
      req =
        method: 'POST'
        url: SERVER_URL + '/userdoc_visibility/' + document_id
        headers:
          'Content-Type': 'application/json'
        data:
          'visible': userDocument.visible
      $http(req).then(
        (success) ->
        (error) ->
          $scope.$parent.alert("Error: #{error.data} (#{error.status})", 'danger')
          userDocument.visible = previousValue
      )

    $scope.getVisibilityToggleClassFor = (userDocument) ->
      if userDocument.visible
        return "glyphicon glyphicon-eye-open"
      else
        return "glyphicon glyphicon-eye-close text-muted"

    getTasks = () ->
      $scope.loading = true
      $http.get(SERVER_URL + "/tasks").then(
        (response) ->
          $scope.tasks = response.data
          $scope.files = ([] for i in [0..$scope.tasks.length])
          $scope.loading = false
          if $scope.tasks and $scope.tasks.length > 0
            $scope.expandTask $scope.tasks[0]
        (error) ->
          $scope.$parent.alert("An error occurred while fetching the tasks.", "danger")
          $scope.loading = false
      )

    getDetailsFor = (task) ->
      $scope.loading = true
      $http.get(SERVER_URL + "/tasks/" + task.task_id).then(
        (response) ->
          $scope.documents = response.data.documents
          $scope.loading = false
        (error) ->
          $scope.$parent.alert("An error occurred while fetching task details: \"#{error.data}\"", "danger")
          $scope.loading = false
      )

    getDocumentDetailsFor = (doc) ->
      $scope.loadingDocument = true
      $http.get(SERVER_URL + "/user_documents_for/" + doc.document_id).then(
        (response) ->
          $scope.userDocuments = response.data
          $scope.loadingDocument = false
        (error) ->
          $scope.$parent.alert("An error occurred while fetching document details: \"#{error.data}\"", "danger")
          $scope.loadingDocument = false
      )

    updateUserCountFor = (doc) ->
      for element in $scope.documents
        if element.document_id == doc.document_id
          element.user_document_count = element.user_document_count - 1
          break

    uploadDocument = (name, content) ->
      $scope.$parent.alert("Uploading and importing #{name}...")
      doc_type = 'plaintext'
      if name.slice(-3) == 'xml'
        doc_type = 'bioc'
      req =
        method: 'POST'
        url: SERVER_URL + '/import'
        headers:
          'Content-Type': 'application/json'
        data:
          'type': doc_type
          'document_id': name
          'text': content
          'visibility': 1
          'task': $scope.expandedTask.task_id
      $http(req).then(
        (success) ->
          getDetailsFor($scope.expandedTask)
          $scope.$parent.clearAlerts()
          $scope.$parent.alert("Successfully imported #{name}.", 'success')
        (error) ->
          $scope.$parent.alert("Error: #{error.data} (#{error.status})", 'danger')
      )

    getTasks()
    return
