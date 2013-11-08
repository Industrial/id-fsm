{ EventEmitter } = require 'events'
{ State }        = require './State'

#log = console~log

export class StateMachine extends EventEmitter
  (options) ->
    @states = {}

    if options.attach-target?
      @attach-target = options.attach-target

    for k, v of options.states
      if @attach-target?
        v.attach-target = @attach-target

      @add-state new State this, k, v

    @transition options.initial-state

  # Adds a State to the StateMachine.
  #
  # add-state :: State -> Undefined
  #
  add-state: (state) !->
    #log 'StateMachine#add-state', state.name

    @states[state.name] = state

  # Calls the trigger function on the current state.
  #
  # trigger :: String -> ... -> Undefined
  #
  trigger: (event, ...args) !->
    #log 'StateMachine#trigger', event, ...args

    current-state = @states[@current-state.name]
    current-state.trigger event, ...args

  # Leaves the current state, sets the current state to the new state and enters
  # the new state.
  #
  # transition :: String -> Undefined
  #
  transition: (name) !->
    #log 'StateMachine#transition', name

    enter = (cb) !~>
      @current-state = @states[name]

      @current-state.once 'entered', !~>
        @emit 'transitioned', name

      @current-state.enter!

    leave = (cb) !~>
      @current-state.once 'left', !~>
        @emit 'transitioned', name

        cb!

      @current-state.leave!

    if @current-state?
      <~! leave
      enter!
    else
      enter!
