module Data.Options
  ( Options()
  , Option()
  , IsOption
  , assoc, (:=)
  , optionFn
  , options
  , opt, key
  ) where

import Prelude

import Data.Foreign (Foreign())

import Data.Function (Fn2(), runFn2)

import Data.Maybe (Maybe(..))

import Data.Monoid (Monoid)

import Unsafe.Coerce (unsafeCoerce)

foreign import data Options :: * -> *

foreign import data Option :: * -> * -> *

class IsOption value where
  assoc :: forall opt. Option opt value -> value -> Options opt

infixr 6 :=

(:=) :: forall opt value. (IsOption value) => Option opt value -> value -> Options opt
(:=) = assoc

instance semigroupOptions :: Semigroup (Options a) where
  append = runFn2 appendFn

instance monoidOptions :: Monoid (Options a) where
  mempty = memptyFn

instance isOptionString :: IsOption String where
  assoc = runFn2 isOptionPrimFn

instance isOptionBoolean :: IsOption Boolean where
  assoc = runFn2 isOptionPrimFn

instance isOptionNumber :: IsOption Number where
  assoc = runFn2 isOptionPrimFn

instance isOptionInt :: IsOption Int where
  assoc = runFn2 isOptionPrimFn

instance isOptionRecord :: IsOption { | a } where
  assoc = runFn2 isOptionPrimFn

instance isOptionUnit :: IsOption Unit where
  assoc = runFn2 isOptionPrimFn

instance isOptionFunction :: IsOption (a -> b) where
  assoc = runFn2 isOptionPrimFn

instance isOptionArray :: (IsOption a) => IsOption (Array a) where
  assoc k vs = joinFn $ assoc (optionFn k) <$> vs

instance isOptionMaybe :: (IsOption a) => IsOption (Maybe a) where
  assoc k Nothing = memptyFn
  assoc k (Just a) = assoc (optionFn k) a

optionFn :: forall opt from to. Option opt from -> Option opt to
optionFn = unsafeCoerce

key :: forall opt value. Option opt value -> String
key = unsafeCoerce

opt :: forall opt value. (IsOption value) => String -> Option opt value
opt = unsafeCoerce

foreign import memptyFn :: forall a. Options a

foreign import appendFn :: forall a. Fn2 (Options a) (Options a) (Options a)

foreign import joinFn :: forall a b. Array (Options a) -> Options b

foreign import isOptionPrimFn :: forall b a. Fn2 (Option b a) a (Options b)

foreign import options :: forall a. Options a -> Foreign
