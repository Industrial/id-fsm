{ EventEmitter } = require 'events'
{ State }        = require './State'

export class StateMachine extends EventEmitter
  (options) ->
    @states = {}

    # TODO: Document the attach-target
    if options.attach-target?
      @attach-target = options.attach-target

    # Add all states defined in the options.
    for k, v of options.states
      if @attach-target?
        v.attach-target = @attach-target

      @add-state new State this, k, v

    # Enter the initial state
    <~! @_enter-state @states[options.initial-state]

  # TODO: Document
  _enter-state: (state, cb) !->
    @current-state = state
    @current-state.once 'entered', cb
    @current-state.enter!

  # TODO: Document
  _leave-state: (fsm, cb) !->
    @current-state.once 'left', cb
    @current-state.leave!

  # Adds a State to the StateMachine.
  add-state: (state) !->
    @states[state.name] = state

  # Calls the trigger function on the current state.
  trigger: (event, ...args) !->
    current-state = @states[@current-state.name]
    current-state.trigger event, ...args

  # Leaves the current state, sets the current state to the new state and
  # enters the new state.
  transition: (name) !->
    <~! @_leave-state @current-state
    <~! @_enter-state @states[name]
    @emit name
