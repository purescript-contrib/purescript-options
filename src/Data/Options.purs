module Data.Options
  ( Options()
  , runOptions
  , options
  , Option(..)
  , assoc, (:=)
  , massoc, (:=?)
  , opt, key
  , defaultToOptions
  ) where

import Prelude

import Data.Foreign (toForeign, Foreign())

import Data.Maybe (Maybe(), maybe)

import Data.Monoid (mempty, Monoid)

import Data.Tuple (Tuple(..))

import Data.StrMap as StrMap

import Data.Functor.Contravariant (Contravariant)

-- | The `Options` type represents a set of options. The type argument is a
-- | phantom type, which is useful for ensuring that options for one particular
-- | API are not accidentally passed to some other API.
newtype Options opt =
  Options (Array (Tuple String Foreign))

runOptions :: forall opt. Options opt -> Array (Tuple String Foreign)
runOptions (Options xs) = xs

instance semigroupOptions :: Semigroup (Options opt) where
  append (Options xs) (Options ys) = Options (xs <> ys)

instance monoidOptions :: Monoid (Options opt) where
  mempty = Options []

-- | Convert an `Options` value into a JavaScript object, suitable for passing
-- | to JavaScript APIs.
options :: forall opt. Options opt -> Foreign
options = toForeign <<< StrMap.fromFoldable <<< runOptions

-- | An `Option` represents an opportunity to configure a specific attribute
-- | of a call to some API. This normally corresponds to one specific property
-- | of an "options" object in JavaScript APIs.
newtype Option opt value =
  Option
    { key :: String
    , toOptions :: String -> value -> Options opt
    }

instance contravariantOption :: Contravariant (Option opt) where
  cmap f (Option o) =
    Option
      { key: o.key
      , toOptions: \k v -> o.toOptions k (f v)
      }

-- | Associates a value with a specific option.
assoc :: forall opt value. Option opt value -> value -> Options opt
assoc (Option o) value = o.toOptions o.key value

infixr 6 :=

-- | An infix version of `assoc`.
(:=) :: forall opt value. Option opt value -> value -> Options opt
(:=) = assoc

-- | A version of `assoc` which takes possibly absent values. `Nothing` values
-- | are ignored; passing `Nothing` for the second argument will result in an
-- | empty `Options`.
massoc :: forall opt value. Option opt value -> Maybe value -> Options opt
massoc option = maybe mempty (option :=)

infixr 6 :=?

(:=?) :: forall opt value. Option opt value -> Maybe value -> Options opt
(:=?) = massoc

-- | The default way of creating `Option` values. Constructs an `Option` with
-- | the given key, which passes the given value through unchanged.
opt :: forall opt value. String -> Option opt value
opt k = Option { key: k, toOptions: defaultToOptions }

-- | Get the `String` key of an `Option`.
key :: forall opt value. Option opt value -> String
key (Option o) = o.key

-- | The default method for turning a string property key and a value into an
-- | `Options` value. This function simply calls `toForeign` on the value. If
-- | you need some other behaviour, you can write your own function to replace
-- | this one, and construct an `Option` yourself.
defaultToOptions :: forall opt value. String -> value -> Options opt
defaultToOptions k v = Options [Tuple k (toForeign v)]
