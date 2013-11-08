require! <[ assert net ]>

{ type-check }   = require 'type-check'
{ State }        = require '../lib/State'
{ StateMachine } = require '../lib/StateMachine'

describe 'StateMachine', ->
  ``it`` 'should have set default properties', ->
    fsm = new StateMachine do
      initial-state: '1'
      states:
        1:
          events: {}

    assert type-check 'Object', fsm.states
    assert type-check 'Object', fsm.current-state

  describe 'add-state', ->
    ``it`` 'should have added the state', (cb) ->
      fsm = new StateMachine do
        initial-state: '1'
        states:
          1:
            events: {}

      fsm.add-state new State fsm, '2', events: {}

      assert fsm.states.2 instanceof State

      cb!

  describe 'trigger', ->
    ``it`` 'should have called the trigger method on the state', (cb) ->
      fsm = new StateMachine do
        initial-state: '1'
        states:
          1:
            events:
              foo: cb

      fsm.trigger 'foo'

  describe 'transition', ->
    ``it`` 'should have left the first state', (cb) ->
      fsm = new StateMachine do
        initial-state: '1'
        states:
          1:
            events: {}

          2:
            events: {}

      fsm.states.1.once 'left', cb

      fsm.transition '2'

    ``it`` 'should have entered the second state', (cb) ->
      fsm = new StateMachine do
        initial-state: '1'
        states:
          1:
            events: {}

          2:
            events: {}

      fsm.states.2.once 'entered', cb

      fsm.transition '2'
