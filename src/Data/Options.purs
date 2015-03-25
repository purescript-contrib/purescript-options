module Data.Options
  ( Options()
  , Option()
  , IsOption
  , optionFn
  , options
  , opt
  , key
  , (:=)
  ) where

import Data.Foreign (Foreign())
import Data.Function (Fn2(), runFn2)
import Data.Maybe (Maybe(..))
import Data.Monoid (Monoid)

foreign import data Options :: * -> *

foreign import data Option :: * -> * -> *

infixr 6 :=

class IsOption r where
  (:=) :: forall a. Option a r -> r -> Options a

foreign import optionFn "function optionFn(a){return a;}" :: forall r s a. Option a r -> Option a s

instance semigroupOptions :: Semigroup (Options a) where
  (<>) = runFn2 appendFn

instance monoidOptions :: Monoid (Options a) where
  mempty = memptyFn

instance isOptionString :: IsOption String where
  (:=) = runFn2 isOptionPrimFn

instance isOptionBoolean :: IsOption Boolean where
  (:=) = runFn2 isOptionPrimFn

instance isOptionNumber :: IsOption Number where
  (:=) = runFn2 isOptionPrimFn

instance isOptionRecord :: IsOption { | a } where
  (:=) = runFn2 isOptionPrimFn

instance isOptionUnit :: IsOption Unit where
  (:=) = runFn2 isOptionPrimFn

instance isOptionFunction :: IsOption (a -> b) where
  (:=) = runFn2 isOptionPrimFn

instance isOptionArray :: (IsOption a) => IsOption [a] where
  (:=) k vs = joinFn $ (:=) (optionFn k) <$> vs

instance isOptionMaybe :: (IsOption a) => IsOption (Maybe a) where
  (:=) k Nothing = memptyFn
  (:=) k (Just a) = (optionFn k) := a

foreign import memptyFn "var memptyFn = [];" :: forall a. Options a

foreign import appendFn """
  function appendFn(o1, o2) {
    return o1.concat(o2);
  }
""" :: forall a. Fn2 (Options a) (Options a) (Options a)

foreign import joinFn """
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
""" :: forall a b. [Options a] -> Options b

foreign import isOptionPrimFn """
  function isOptionPrimFn(k, v) {
    return [[k, v]];
  }
""" :: forall b a. Fn2 (Option b a) a (Options b)

foreign import options """
  function options(o) {
    var res = {};
    var i = -1;
    var n = o.length;
    while(++i < n) {
      var k = o[i][0];
      var v = o[i][1];
      res[k] = v;
    }
    return res;
  }
""" :: forall a. Options a -> Foreign

foreign import opt """
  function opt(dict) {
    return function(k){
      return k;
    }
  }
""" :: forall k v. (IsOption v) => String -> Option k v

foreign import key """
  function key(o){
    return o;
  }
""" :: forall k v. Option k v -> String
