module Data.Options
  ( Options()
  , runOptions
  , options
  , Option()
  , assoc, (:=)
  , optional
  , opt
  , tag
  , defaultToOptions
  ) where

import Prelude (class Semigroup, Unit, (<<<), ($), (<>))

import Data.Foreign (toForeign, Foreign())
import Data.Maybe (Maybe(), maybe)
import Data.Monoid (mempty, class Monoid)
import Data.Op (Op(Op), runOp)
import Data.StrMap as StrMap
import Data.Tuple (Tuple(..))

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
-- | of an "options" object in JavaScript APIs, but can in general correspond
-- | to zero or more actual properties.
type Option opt = Op (Options opt)

-- | Associates a value with a specific option.
assoc :: forall opt value. Option opt value -> value -> Options opt
assoc o value = runOp o value

-- | An infix version of `assoc`.
infixr 6 assoc as :=

-- | A version of `assoc` which takes possibly absent values. `Nothing` values
-- | are ignored; passing `Nothing` for the second argument will result in an
-- | empty `Options`.
optional :: forall opt value. Option opt value -> Option opt (Maybe value)
optional option = Op $ maybe mempty (option := _)

-- | The default way of creating `Option` values. Constructs an `Option` with
-- | the given key, which passes the given value through unchanged.
opt :: forall opt value. String -> Option opt value
opt = Op <<< defaultToOptions

-- | Create a `tag`, by fixing an `Option` to a single value.
tag :: forall opt value. Option opt value -> value -> Option opt Unit
tag o value = Op \_ -> o := value

-- | The default method for turning a string property key into an
-- | `Option`. This function simply calls `toForeign` on the value. If
-- | you need some other behaviour, you can write your own function to replace
-- | this one, and construct an `Option` yourself.
defaultToOptions :: forall opt value. String -> value -> Options opt
defaultToOptions k v = Options [Tuple k (toForeign v)]
