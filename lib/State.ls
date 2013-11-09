require! <[ async ]>

{ EventEmitter } = require 'events'

export class State extends EventEmitter
  (@fsm = null, @name, options) ->
    @enter-middleware = []
    @leave-middleware = []
    @events           = options.events or {}

    if options.attach-target?
      @attach-target = options.attach-target

    if options.enter?
      @enter-using options.enter

    if options.leave?
      @leave-using options.leave

    if options.middleware?
      for v in options.middleware
        if v.enter?
          @enter-using v.enter

        if v.leave?
          @leave-using v.leave

  # Enters the state
  enter: !->
    if @attach-target?
      for k, v of @events
        @attach-target[k] = v

    <~! async.series @enter-middleware

    @emit 'entered'

  # Leaves the state
  leave: !->
    <~! async.series @leave-middleware

    if @attach-target?
      for k, v of @events
        delete @attach-target[k]

    @emit 'left'

  # Adds handler to the enter callback chain.
  enter-using: (fn) !->
    @enter-middleware.unshift fn

  # Adds handler to the leave callback chain.
  leave-using: (fn) !->
    @leave-middleware.unshift fn

  # Calls an event function.
  trigger: (event, ...args) !->
    handler = @events[event]

    if handler?
      handler.apply this, args

  # Tells the StateMachine to transition to another State when defined. This
  # method is essentially a pass-through and the reason why the StateMachine
  # may be defined on the State. It is here because event functions are bound to
  # the state. By calling this method the state machine can change from state to
  # state declaratively.
  transition: (...args) !->
    @fsm?.transition ...args
