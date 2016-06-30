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

    $scope.generateExportUserDocumentLinkFor = (userDocument) ->
      return SERVER_URL + '/export/' + $scope.expandedDocument.document_id + '?user_id=' + userDocument.user_id

    $scope.deleteUserDocument = (userDocument) ->
      if confirm("Are you sure that you want to delete all annotations " +
                  "made by " + userDocument.user_name + " in this document? "+
                  "This cannot be undone.")
        req =
          method: 'DELETE'
          url: SERVER_URL + '/user_documents/' + userDocument.id
        $http(req).then(
          (success) ->
            getDocumentDetailsFor($scope.expandedDocument)
            updateUserCountFor($scope.expandedDocument)
            Popup.show("Document successfully deleted.", 'success', 5000)
          (error) ->
            Popup.show("Error: #{error.data} (#{error.status})", 'danger', 10000)
        )

    $scope.generateTextAELinkFor = (doc) ->
      landingURL = "/dist/textae/textae.html?mode=edit&hana-document=#{doc.document_id}&tid=#{$scope.expandedTask.task_id}"
      return SERVER_URL + landingURL

    $scope.deleteDocument = (doc) ->
      if confirm("Are you sure that you want to delete this document including all annotations? This cannot be undone.")
        req =
          method: 'DELETE'
          url: SERVER_URL + '/documents/' + doc.document_id
        $http(req).then(
          (success) ->
            getDetailsFor($scope.expandedTask)
            Popup.show("Document successfully deleted.", 'success', 5000)
          (error) ->
            Popup.show("Error: #{error.data} (#{error.status})", 'danger', 10000)
        )

    $scope.upload = () ->
      for file in $scope.files[$scope.expandedTask.task_id]
        uploadDocument(file.name, file.body)
      $scope.files[$scope.expandedTask.task_id] = []

    $scope.uploadFromPubmed = () ->
      $http.get(SERVER_URL + '/pubmed/' + $scope.expandedTask.pubmedId).then(
        (response) ->
          uploadDocument('pubmed_' + $scope.expandedTask.pubmedId, response.data)
          $scope.pubmedId = undefined
        (error) ->
          if error.data and error.status
            Popup.show("An error occurred: '#{error.data}' (#{error.status}).", 'danger', 10000)
          else
            Popup.show('There was a problem retrieving the document from PubMed.', 'danger', 10000)
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
          Popup.show("Predictions created.", 'success', 5000)
        (error) ->
          Popup.show("Error: #{error.data} (#{error.status})", 'danger', 10000)
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
          Popup.show("Error: #{error.data} (#{error.status})", 'danger', 10000)
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
          $scope.documents = []
          $scope.files = ([] for i in [0..$scope.tasks.length])
          $scope.loading = false
          if $scope.tasks and $scope.tasks.length == 1
            $scope.expandTask $scope.tasks[0]
        (error) ->
          Popup.show("An error occurred while fetching the tasks.", "danger", 10000)
          $scope.loading = false
      )

    getDetailsFor = (task) ->
      $scope.loading = true
      $http.get(SERVER_URL + "/tasks/" + task.task_id).then(
        (response) ->
          $scope.documents = response.data.documents
          $scope.loading = false
        (error) ->
          Popup.show("An error occurred while fetching task details: \"#{error.data}\"", "danger", 10000)
          $scope.loading = false
      )

    getDocumentDetailsFor = (doc) ->
      $scope.loadingDocument = true
      $http.get(SERVER_URL + "/user_documents_for/" + doc.document_id).then(
        (response) ->
          $scope.userDocuments = response.data
          $scope.loadingDocument = false
        (error) ->
          Popup.show("An error occurred while fetching document details: \"#{error.data}\"", "danger", 10000)
          $scope.loadingDocument = false
      )

    updateUserCountFor = (doc) ->
      for element in $scope.documents
        if element.document_id == doc.document_id
          element.user_document_count = element.user_document_count - 1
          break

    uploadDocument = (name, content) ->
      $scope.$parent.clearAlerts()
      Popup.show("Uploading and importing #{name}...", 10000)
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
          Popup.show("Successfully imported #{name}.", 'success', 10000)
        (error) ->
          Popup.show("Error: #{error.data} (#{error.status})", 'danger', 10000)
      )

    getTasks()
    return
