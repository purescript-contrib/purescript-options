module Test.Main where

import Prelude

import Data.Functor.Contravariant (cmap)
import Data.Maybe (Maybe(..))
import Data.Options (Option, Options, optional, options, opt, (:=))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Foreign (Foreign)
import Test.Spec (it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

data Shape = Circle | Square | Triangle

instance shapeShow :: Show Shape where
  show Circle = "circle"
  show Square = "square"
  show Triangle = "triangle"

foreign import data Foo :: Type

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

opts :: Options Foo
opts = foo := "aaa" <>
       bar := 10 <>
       baz := true <>
       bam := Just "c" <>
       fiz := Nothing <>
       biz := Square <>
       buz := (\a b c -> a + b + c) <>
       fuz := [Square, Circle, Triangle]

foreign import showForeign :: Foreign -> String

main :: Effect Unit
main = do
  launchAff_
    $ runSpec [ consoleReporter ] do
        it "works as expected" do
          let expected = """{"foo":"aaa","bar":10,"baz":true,"bam":"c","shape":"square","fuz":["square","circle","triangle"]}"""
          let actual = showForeign $ options opts

          actual `shouldEqual` expected
