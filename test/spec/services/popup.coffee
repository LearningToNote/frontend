'use strict'

describe 'Service: Popup', ->

  timerCallback = null

  # load the service's module
  beforeEach module 'frontendApp'

  # instantiate service
  Popup = {}
  beforeEach inject (_Popup_) ->
    Popup = _Popup_

  it 'should initialize with no popups', ->
    expect(Popup.popups.length).toBe 0

  it 'should add popups with a generated id', ->
    Popup.show('foo', 'bar')
    expect(Popup.popups[0].id).toBeDefined()

  it 'should delete popups with a timer after the given time', inject ($timeout) ->
    Popup.show('foo', 'bar', 1000)
    expect(Popup.popups.length).toBe 1

    $timeout.flush()
    $timeout.verifyNoPendingTasks()

    expect(Popup.popups.length).toBe 0
