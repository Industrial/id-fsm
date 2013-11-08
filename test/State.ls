require! <[ assert net ]>

{ type-check }   = require 'type-check'
{ State }        = require '../lib/State'
{ StateMachine } = require '../lib/StateMachine'

describe 'State', ->
  ``it`` 'should have set default properties', ->
    s = new State null, 'TestState' do
      events: {}

    assert type-check 'Object', s.events
    assert type-check 'Array', s.enter-middleware
    assert type-check 'Array', s.leave-middleware

  describe 'enter', ->
    describe 'when no middleware was defined', ->
      ``it`` 'should have emitted the entered event', (cb) ->
        s = new State null, 'TestState' do
          events: {}

        s.on 'entered', cb

        s.enter!

    describe 'when middleware was defined', ->
      ``it`` 'should have called each middleware', (cb) ->
        x = 0
        s = new State null, 'TestState' do
          enter: (cb) ->
            assert.equal 5, x
            cb!

          middleware: [
            { enter: (cb) -> x++; cb! },
            { enter: (cb) -> x++; cb! },
            { enter: (cb) -> x++; cb! },
            { enter: (cb) -> x++; cb! },
            { enter: (cb) -> x++; cb! },
          ]

          events: {}

        s.on 'entered', cb

        s.enter!

  describe 'leave', ->
    describe 'when no middleware was defined', ->
      ``it`` 'should have emitted the left event', (cb) ->
        s = new State null, 'TestState' do
          events: {}

        s.on 'left', cb

        s.leave!

    describe 'when middleware was defined', ->
      ``it`` 'should have called each middleware', (cb) ->
        x = 0
        s = new State null, 'TestState' do
          leave: (cb) ->
            assert.equal 5, x
            cb!

          middleware: [
            { leave: (cb) -> x++; cb! },
            { leave: (cb) -> x++; cb! },
            { leave: (cb) -> x++; cb! },
            { leave: (cb) -> x++; cb! },
            { leave: (cb) -> x++; cb! },
          ]

          events: {}

        s.on 'left', cb

        s.leave!

  describe 'enter-using', ->
    ``it`` 'should have added the middleware', (cb) ->
        s = new State null, 'TestState' do
          events: {}

        assert.equal 0, s.enter-middleware.length

        s.enter-using ->

        assert.equal 1, s.enter-middleware.length

        cb!

  describe 'leave-using', ->
    ``it`` 'should have added the middleware', (cb) ->
        s = new State null, 'TestState' do
          events: {}

        assert.equal 0, s.leave-middleware.length

        s.leave-using ->

        assert.equal 1, s.leave-middleware.length

        cb!

  describe 'trigger', ->
    describe 'when no handler for this event was defined', ->
      ``it`` 'should have done nothing', (cb) ->
          s = new State null, 'TestState' do
            events: {}

          s.trigger 'foo'
          s.trigger 'bar'
          s.trigger 'baz'

          cb!

    describe 'when a handler for this event was defined', ->
      ``it`` 'should have called the handler', (cb) ->
          s = new State null, 'TestState' do
            events:
              foo: cb

          s.trigger 'foo'

  describe 'transition', ->
    ``it`` 'should have called the statemachine trigger method', (cb) ->
      fsm = new StateMachine do
        initial-state: 'one'
        states:
          one:
            events: {}
          two:
            events: {}

      fsm.transition = ->
        cb!

      fsm.current-state.transition 'two'

