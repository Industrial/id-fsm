// Generated by LiveScript 1.2.0
var assert, net, typeCheck, State, StateMachine;
assert = require('assert');
net = require('net');
typeCheck = require('type-check').typeCheck;
State = require('../lib/State').State;
StateMachine = require('../lib/StateMachine').StateMachine;
describe('StateMachine', function(){
  it('should have set default properties', function(){
    var fsm;
    fsm = new StateMachine({
      initialState: '1',
      states: {
        1: {
          events: {}
        }
      }
    });
    assert(typeCheck('Object', fsm.states));
    return assert(typeCheck('Object', fsm.currentState));
  });
  describe('add-state', function(){
    return it('should have added the state', function(cb){
      var fsm;
      fsm = new StateMachine({
        initialState: '1',
        states: {
          1: {
            events: {}
          }
        }
      });
      fsm.addState(new State(fsm, '2', {
        events: {}
      }));
      assert(fsm.states[2] instanceof State);
      return cb();
    });
  });
  describe('trigger', function(){
    return it('should have called the trigger method on the state', function(cb){
      var fsm;
      fsm = new StateMachine({
        initialState: '1',
        states: {
          1: {
            events: {
              foo: cb
            }
          }
        }
      });
      return fsm.trigger('foo');
    });
  });
  return describe('transition', function(){
    it('should have left the first state', function(cb){
      var fsm;
      fsm = new StateMachine({
        initialState: '1',
        states: {
          1: {
            events: {}
          },
          2: {
            events: {}
          }
        }
      });
      fsm.states[1].once('left', cb);
      return fsm.transition('2');
    });
    return it('should have entered the second state', function(cb){
      var fsm;
      fsm = new StateMachine({
        initialState: '1',
        states: {
          1: {
            events: {}
          },
          2: {
            events: {}
          }
        }
      });
      fsm.states[2].once('entered', cb);
      return fsm.transition('2');
    });
  });
});