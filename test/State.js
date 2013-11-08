// Generated by LiveScript 1.2.0
var assert, net, typeCheck, State, StateMachine, log;
assert = require('assert');
net = require('net');
typeCheck = require('type-check').typeCheck;
State = require('../lib/State').State;
StateMachine = require('../lib/StateMachine').StateMachine;
log = bind$(console, 'log');
describe('State', function(){
  it('should have set default properties', function(){
    var s;
    s = new State(null, 'TestState', {
      events: {}
    });
    assert(typeCheck('Object', s.events));
    assert(typeCheck('Array', s.enterMiddleware));
    return assert(typeCheck('Array', s.leaveMiddleware));
  });
  describe('enter', function(){
    describe('when no middleware was defined', function(){
      return it('should have emitted the entered event', function(cb){
        var s;
        s = new State(null, 'TestState', {
          events: {}
        });
        s.on('entered', cb);
        return s.enter();
      });
    });
    return describe('when middleware was defined', function(){
      return it('should have called each middleware', function(cb){
        var x, s;
        x = 0;
        s = new State(null, 'TestState', {
          enter: function(cb){
            assert.equal(5, x);
            return cb();
          },
          middleware: [
            {
              enter: function(cb){
                x++;
                return cb();
              }
            }, {
              enter: function(cb){
                x++;
                return cb();
              }
            }, {
              enter: function(cb){
                x++;
                return cb();
              }
            }, {
              enter: function(cb){
                x++;
                return cb();
              }
            }, {
              enter: function(cb){
                x++;
                return cb();
              }
            }
          ],
          events: {}
        });
        s.on('entered', cb);
        return s.enter();
      });
    });
  });
  describe('leave', function(){
    describe('when no middleware was defined', function(){
      return it('should have emitted the left event', function(cb){
        var s;
        s = new State(null, 'TestState', {
          events: {}
        });
        s.on('left', cb);
        return s.leave();
      });
    });
    return describe('when middleware was defined', function(){
      return it('should have called each middleware', function(cb){
        var x, s;
        x = 0;
        s = new State(null, 'TestState', {
          leave: function(cb){
            assert.equal(5, x);
            return cb();
          },
          middleware: [
            {
              leave: function(cb){
                x++;
                return cb();
              }
            }, {
              leave: function(cb){
                x++;
                return cb();
              }
            }, {
              leave: function(cb){
                x++;
                return cb();
              }
            }, {
              leave: function(cb){
                x++;
                return cb();
              }
            }, {
              leave: function(cb){
                x++;
                return cb();
              }
            }
          ],
          events: {}
        });
        s.on('left', cb);
        return s.leave();
      });
    });
  });
  describe('enter-using', function(){
    return it('should have added the middleware', function(cb){
      var s;
      s = new State(null, 'TestState', {
        events: {}
      });
      assert.equal(0, s.enterMiddleware.length);
      s.enterUsing(function(){});
      assert.equal(1, s.enterMiddleware.length);
      return cb();
    });
  });
  describe('leave-using', function(){
    return it('should have added the middleware', function(cb){
      var s;
      s = new State(null, 'TestState', {
        events: {}
      });
      assert.equal(0, s.leaveMiddleware.length);
      s.leaveUsing(function(){});
      assert.equal(1, s.leaveMiddleware.length);
      return cb();
    });
  });
  describe('trigger', function(){
    describe('when no handler for this event was defined', function(){
      return it('should have done nothing', function(cb){
        var s;
        s = new State(null, 'TestState', {
          events: {}
        });
        s.trigger('foo');
        s.trigger('bar');
        s.trigger('baz');
        return cb();
      });
    });
    return describe('when a handler for this event was defined', function(){
      return it('should have called the handler', function(cb){
        var s;
        s = new State(null, 'TestState', {
          events: {
            foo: cb
          }
        });
        return s.trigger('foo');
      });
    });
  });
  return describe('transition', function(){
    return it('should have called the statemachine trigger method', function(cb){
      var fsm;
      fsm = new StateMachine({
        initialState: 'one',
        states: {
          one: {
            events: {}
          },
          two: {
            events: {}
          }
        }
      });
      fsm.transition = function(){
        return cb();
      };
      return fsm.currentState.transition('two');
    });
  });
});
function bind$(obj, key, target){
  return function(){ return (target || obj)[key].apply(obj, arguments) };
}