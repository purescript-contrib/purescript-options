'use strict';

// module Data.Options

var memptyFn = [];

function appendFn(o1, o2) {
  return o1.concat(o2);
}

function joinFn(os) {
  var k = null;
  var vs = [];
  var i = -1;
  var n = os.length;
  while(++i < n) {
    k = os[i][0][0];
    vs.push(os[i][0][1]);
  }
  return [[k, vs]];
}

function isOptionPrimFn(k, v) {
  return [[k, v]];
}

function options(o) {
  var res = {};
  var n = o.length;
  var i;
  for (i = 0; i < n; i++) {
    var k = o[i][0];
    var v = o[i][1];
    res[k] = v;
  }
  return res;
}

function runOptionsFn(Tuple) {
  return function(o){
    var res = [];
    var n = o.length;
    var i;
    for (i = 0; i < n; i++) {
      var k = o[i][0];
      var v = o[i][1];
      res[i] = Tuple(k)(v);
    }
    return res;
  };
}

exports.memptyFn = memptyFn;

exports.appendFn = appendFn;

exports.joinFn = joinFn;

exports.isOptionPrimFn = isOptionPrimFn;

exports.options = options;

exports.runOptionsFn = runOptionsFn
