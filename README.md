# id-fsm - [![Build Status](https://secure.travis-ci.org/Industrial/id-fsm.png)](http://travis-ci.org/Industrial/id-fsm)

Small Finite State Machine implementation using LiveScript mainly for controlling (async) flow.

## Installation

    npm install --save id-fsm

## Usage

### Simple example

```js
    var idFSM = require('id-fsm');

    var trafficLight = new idFSM.StateMachine({
      initialState: 'Red',

      states: {
        Red: {
          events: {
            goGreen: function() {
              this.transition('Green');
            }
          }
        },

        Orange: {
          events: {
            goRed: function() {
              this.transition('Red');
            }
          }
        },

        Green: {
          events: {
            goOrange: function() {
              this.transition('Orange');
            }
          }
        }
      }
    });

    trafficLight.on('Red',    function() { console.log('Red');    });
    trafficLight.on('Orange', function() { console.log('Orange'); });
    trafficLight.on('Green',  function() { console.log('Green');  });

    trafficLight.trigger('goGreen');
    trafficLight.trigger('goOrange');
    trafficLight.trigger('goRed');
```

### Enter and Leave handlers

When a state is entered or left, if an enter or leave property was defined for
the state, it will call it before entering and after leaving the state.

```js
    var idFSM = require('id-fsm');

    var trafficLight = new idFSM.StateMachine({
      initialState: 'Red',

      states: {
        Red: {
          enter: function(cb) {
            console.log 'Entered Red.'
            cb();
          },

          events: {
            goGreen: function() {
              this.transition('Green');
            }
          },

          leave: function(cb) {
            console.log 'Left Red.'
            cb();
          }
        },

        Orange: {
          events: {
            goRed: function() {
              this.transition('Red');
            }
          }
        },

        Green: {
          events: {
            goOrange: function() {
              this.transition('Orange');
            }
          }
        }
      }
    });

    trafficLight.on('Red',    function() { console.log('Red');    });
    trafficLight.on('Orange', function() { console.log('Orange'); });
    trafficLight.on('Green',  function() { console.log('Green');  });

    trafficLight.trigger('goGreen');
    trafficLight.trigger('goOrange');
    trafficLight.trigger('goRed');
```

### Enter and Leave middleware

You can define middleware for states that will be ran when entering or leaving
a state to decorate that state with behaviour:

```js
    var idFSM = require('id-fsm');

    var loggingMiddleware = function(options) {
      return {
        enter: function(cb) {
          console.log('entered a state');
          cb();
        },

        leave: function(cb) {
          console.log('left a state');
          cb();
        }
      };
    };

    var trafficLight = new idFSM.StateMachine({
      initialState: 'Red',

      states: {
        Red: {
          events: {
            goGreen: function() {
              this.transition('Green');
            }
          },

          middleware: [
            loggingMiddleware()
          ]
        },

        Orange: {
          events: {
            goRed: function() {
              this.transition('Red');
            }
          },

          middleware: [
            loggingMiddleware()
          ]
        },

        Green: {
          events: {
            goOrange: function() {
              this.transition('Orange');
            }
          },

          middleware: [
            loggingMiddleware()
          ]
        },
      }
    });

    trafficLight.on('Red',    function() { console.log('Red');    });
    trafficLight.on('Orange', function() { console.log('Orange'); });
    trafficLight.on('Green',  function() { console.log('Green');  });

    trafficLight.trigger('goGreen');
    trafficLight.trigger('goOrange');
    trafficLight.trigger('goRed');
```
