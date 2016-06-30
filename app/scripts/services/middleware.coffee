'use strict'

angular.module('frontendApp').service 'Middleware', ($http) ->

  SERVER_URL = "https://#{location.hostname}:8080"

  self = (options) ->
    options.url = SERVER_URL + options.url
    return $http(options)

  self['SERVER_URL'] = SERVER_URL

  self['get'] = (url, options) -> $http.get(SERVER_URL + url, options)
  self['delete'] = (url, options) -> $http.delete(SERVER_URL + url, options)

  self['post'] = (url, data, options) -> $http.post(SERVER_URL + url, data, options)
  self['put'] = (url, data, options) -> $http.put(SERVER_URL + url, data, options)

  return self
