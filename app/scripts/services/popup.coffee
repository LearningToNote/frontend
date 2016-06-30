'use strict'

angular.module('frontendApp').service 'Popup', ($timeout) ->
  self = {}

  NUMBER_OF_POPUPS = 5

  self.popups = []
  self.counter = 0

  removeElement = (index) ->
    self.popups.splice(index, 1)

  self.show = (message, level, timer) ->
    if self.popups.length >= NUMBER_OF_POPUPS
      removeElement(0)

    self.popups.push {id: self.counter, type: level, msg: message}
    if timer
      $timeout(self.close, timer, true, self.counter)

    self.counter += 1
    return self.counter

  self.close = (id) ->
    for popup, index in self.popups
      if popup and popup.id == id
        removeElement(index)

  self.clear = () ->
    self.popups = []

  return self
