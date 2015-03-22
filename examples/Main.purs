module Main where

import Data.Foreign (Foreign())
import Data.Maybe (Maybe(..))
import Data.Options (Option(), IsOption, optionFn, options, opt, (:=))
import Debug.Trace

data Shape = Circle | Square | Triangle

instance shapeShow :: Show Shape where
  show Circle = "circle"
  show Square = "square"
  show Triangle = "triangle"

instance shapeIsOption :: IsOption Shape where
  (:=) k a = (optionFn k) := show a

foreign import data Foo :: *

foo = opt "foo" :: Option Foo String
bar = opt "bar" :: Option Foo Number
baz = opt "baz" :: Option Foo Boolean
bam = opt "bam" :: Option Foo (Maybe String)
fiz = opt "fiz" :: Option Foo (Maybe String)
biz = opt "biz" :: Option Foo Shape
buz = opt "buz" :: Option Foo (Number -> Number -> Number -> Number)
fuz = opt "fuz" :: Option Foo [Shape]

opts = foo := "aaa" <>
       bar := 10 <>
       baz := true <>
       bam := Just "c" <>
       fiz := Nothing <>
       biz := Square <>
       buz := (\a b c -> a + b + c) <>
       fuz := [Square, Circle, Triangle]

main = (trace <<< showForeign <<< options) opts

foreign import showForeign
  """
    function showForeign(a){
      return JSON.stringify(a);
    }
  """ :: Foreign -> String
