module Main where

import Data.Foreign (Foreign())
import Data.Maybe (Maybe(..))
import Data.Options (Option(), IsOption, optionFn, options, (:=))
import Debug.Trace

data Shape = Circle | Square | Triangle

instance shapeShow :: Show Shape where
  show Circle = "circle"
  show Square = "square"
  show Triangle = "triangle"

instance shapeIsOption :: IsOption Shape where
  (:=) k a = (optionFn k) := show a

foreign import data Foo :: *

foreign import foo "var foo = 'foo';" :: Option Foo String

foreign import bar "var bar = 'bar';" :: Option Foo Number

foreign import baz "var baz = 'baz';" :: Option Foo Boolean

foreign import bam "var bam = 'bam';" :: Option Foo (Maybe String)

foreign import fiz "var fiz = 'fiz';" :: Option Foo (Maybe String)

foreign import biz "var biz = 'biz';" :: Option Foo Shape

opts = foo := "aaa" <>
       bar := 10 <>
       baz := true <>
       bam := Just "c" <>
       fiz := Nothing <>
       biz := Square

main = (trace <<< showForeign <<< options) opts

foreign import showForeign
  """
    function showForeign(a){
      return JSON.stringify(a);
    }
  """ :: Foreign -> String
