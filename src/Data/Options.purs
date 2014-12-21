module Data.Options
  ( Options()
  , Option()
  , IsOption
  , optionFn
  , options
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

instance optionsSemigroup :: Semigroup (Options a) where
  (<>) = runFn2 appendFn

instance optionsMonoid :: Monoid (Options a) where
  mempty = memptyFn

instance stringIsOption :: IsOption String where
  (:=) = runFn2 primIsOptionFn

instance booleanIsOption :: IsOption Boolean where
  (:=) = runFn2 primIsOptionFn

instance numberIsOption :: IsOption Number where
  (:=) = runFn2 primIsOptionFn

instance maybeIsOption :: (IsOption a) => IsOption (Maybe a) where
  (:=) k Nothing = memptyFn
  (:=) k (Just a) = (optionFn k) := a

foreign import appendFn
  """
    function appendFn(o1, o2){
      return o1.concat(o2);
    }
  """ :: forall a. Fn2 (Options a) (Options a) (Options a)

foreign import memptyFn "var memptyFn = [];" :: forall a. Options a

foreign import primIsOptionFn
  """
    function primIsOptionFn(k, v) {
      return [[k, v]];
    }
  """ :: forall b a. Fn2 (Option b a) a (Options b)

foreign import options
  """
    function options(o){
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
