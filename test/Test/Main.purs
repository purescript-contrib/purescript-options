module Test.Main where

import Prelude (class Show, Unit(), (<<<), (<>), (+), ($), map, show)

import Control.Monad.Eff (Eff())
import Control.Monad.Eff.Console (CONSOLE(), log)

import Data.Foreign (Foreign())
import Data.Functor.Contravariant (cmap)
import Data.Maybe (Maybe(..))
import Data.Options (Option(), Options(), optional, options, opt, nestedOpt, (:=))

data Shape = Circle | Square | Triangle

instance shapeShow :: Show Shape where
  show Circle = "circle"
  show Square = "square"
  show Triangle = "triangle"

foreign import data Foo :: *
foreign import data Foo2 :: *

foo :: Option Foo String
foo = opt "foo"

bar :: Option Foo Int
bar = opt "bar"

baz :: Option Foo Boolean
baz = opt "baz"

bam :: Option Foo (Maybe String)
bam = optional (opt "bam")

fiz :: Option Foo (Maybe String)
fiz = optional (opt "fiz")

biz :: Option Foo Shape
biz = cmap show (opt "shape")

buz :: Option Foo (Int -> Int -> Int -> Int)
buz = opt "buz"

fuz :: Option Foo (Array Shape)
fuz = cmap (map show) (opt "fuz")

foo2 :: Option Foo (Options Foo2)
foo2 = nestedOpt "foo2"

foo2bar :: Option Foo2 String
foo2bar = opt "foo2bar"

foo2baz :: Option Foo2 Int
foo2baz = opt "foo2baz"

opts :: Options Foo
opts = foo := "aaa" <>
       bar := 10 <>
       baz := true <>
       bam := Just "c" <>
       fiz := Nothing <>
       biz := Square <>
       buz := (\a b c -> a + b + c) <>
       fuz := [Square, Circle, Triangle] <>
       foo2 := foo2values
  where foo2values =
    foo2bar := "foo2bar" <>
    foo2baz := 2

main :: forall eff. Eff (console :: CONSOLE | eff) Unit
main = log <<< showForeign <<< options $ opts

foreign import showForeign :: Foreign -> String
