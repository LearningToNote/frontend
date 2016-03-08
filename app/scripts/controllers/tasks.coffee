'use strict'

angular.module('frontendApp')
  .controller 'TasksCtrl', ($scope, $http) ->

    SERVER_URL = "https://#{location.hostname}:8080"

    $scope.loading = false
    $scope.allTasks = []
    $scope.configs = ["LTN::ltn_analysis", "EXTRACTION_CORE_ENTERPRISE"]
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
      req =
        method: 'POST'
        url: SERVER_URL + '/tasks/' + task.task_id
        headers:
          'Content-Type': 'application/json'
        data: task
      $http(req).then(
        (success) ->
          $scope.$parent.alert("Update successful.", 'success')
          getTasks()
        (error) ->
          $scope.$parent.alert("Error: #{error.data} (#{error.status})", 'danger')
      )

    $scope.delete = (task) ->
      $http.delete(SERVER_URL + '/tasks/' + task.task_id).then(
        (success) ->
          $scope.$parent.alert("Task deleted.", 'success')
          getTasks()
        (error) ->
          $scope.$parent.alert("Error: #{error.data} (#{error.status})", 'danger')
      )

    getTasks = () ->
      $scope.loading = true
      $http.get(SERVER_URL + "/tasks").then(
        (response) ->
          $scope.allTasks = response.data
          $scope.loading = false
        (error) ->
          $scope.$parent.alert("An error occured while fetching tasks.", "danger")
          $scope.loading = false
      )

    getUsers = () ->
      $scope.laoding = true
      $http.get(SERVER_URL + "/users").then(
        (response) ->
          $scope.users = response.data
          $scope.loading = false
        (error) ->
          $scope.$parent.alert("An error occured while fetching users.", "danger")
          $scope.loading = false
      )

    getTasks()
    getUsers()

    return
