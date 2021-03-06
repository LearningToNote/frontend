'use strict'

angular.module('frontendApp')
  .controller 'TasksCtrl', ($scope, Popup, Middleware) ->

    $scope.expert_view = false
    $scope.loading = false
    $scope.allTasks = []
    $scope.configs = [
      {"config": "LTN::bio_text_entity_recognition", "label": "Biomedical"}
      {"config": "LTN::business_text_entity_recognition", "label": "Business"}
    ]
    $scope.users

    $scope.addTask = () ->
      $scope.allTasks.push {
        'task_id': null
        'task_name': null
        'task_domain': null
        'task_config': null
        'user_id': null
      }

    $scope.update = (task) ->
      return unless task.task_name and task.task_config

      req =
        method: 'POST'
        url: '/tasks/' + task.task_id
        headers:
          'Content-Type': 'application/json'
        data: task
      Middleware(req).then(
        (success) ->
          Popup.show("Update successful.", 'success', 5000)
          getTasks()
        (error) ->
          Popup.show("Error: #{error.data} (#{error.status})", 'danger', 10000)
      )

    $scope.delete = (task) ->
      Middleware.delete('/tasks/' + task.task_id).then(
        (success) ->
          Popup.show("Task deleted.", 'success', 5000)
          getTasks()
        (error) ->
          Popup.show("Error: #{error.data} (#{error.status})", 'danger', 10000)
      )

    $scope.cancel = () ->
      $scope.allTasks.splice(-1, 1)

    getTasks = () ->
      $scope.loading = true
      Middleware.get("/tasks").then(
        (response) ->
          $scope.allTasks = response.data
          $scope.loading = false
        (error) ->
          Popup.show("An error occured while fetching tasks.", "danger", 10000)
          $scope.loading = false
      )

    getTasks()
    return
