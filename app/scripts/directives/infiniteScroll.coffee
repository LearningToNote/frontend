'use strict'

angular.module('frontendApp').directive 'infiniteScroll', [
  '$rootScope'
  '$window'
  '$timeout'
  ($rootScope, $window, $timeout) ->
    { link: (scope, elem, attrs) ->
      checkWhenEnabled = undefined
      handler = undefined
      scrollDistance = undefined
      scrollEnabled = undefined
      $window = angular.element($window)
      elem.css 'overflow-y', 'scroll'
      elem.css 'overflow-x', 'hidden'
      elem.css 'height', 'inherit'
      scrollDistance = 0
      if attrs.infiniteScrollDistance != null
        scope.$watch attrs.infiniteScrollDistance, (value) ->
          scrollDistance = parseInt(value, 10)
      scrollEnabled = true
      checkWhenEnabled = false
      if attrs.infiniteScrollDisabled != null
        scope.$watch attrs.infiniteScrollDisabled, (value) ->
          scrollEnabled = !value
          if scrollEnabled and checkWhenEnabled
            checkWhenEnabled = false
            return handler()
          return
      $rootScope.$on 'refreshStart', (event, parameters) ->
        elem.animate scrollTop: '0'
        return

      handler = ->
        container = undefined
        elementBottom = undefined
        remaining = undefined
        shouldScroll = undefined
        containerBottom = undefined
        container = $(elem.children()[0])
        elementBottom = elem.offset().top + elem.height()
        containerBottom = container.offset().top + container.height()
        remaining = containerBottom - elementBottom
        shouldScroll = remaining <= elem.height() * scrollDistance
        if shouldScroll and scrollEnabled
          if $rootScope.$$phase
            return scope.$eval(attrs.infiniteScroll)
          else
            return scope.$apply(attrs.infiniteScroll)
        else if shouldScroll
          return checkWhenEnabled = true
        return

      elem.on 'scroll', handler
      scope.$on '$destroy', ->
        $window.off 'scroll', handler
      $timeout (->
        if attrs.infiniteScrollImmediateCheck
          if scope.$eval(attrs.infiniteScrollImmediateCheck)
            return handler()
        else
          return handler()
        return
      ), 0
    }
]
