## Module Data.Options

#### `Options`

``` purescript
data Options :: * -> *
```

##### Instances
``` purescript
instance semigroupOptions :: Semigroup (Options a)
instance monoidOptions :: Monoid (Options a)
```

#### `Option`

``` purescript
data Option :: * -> * -> *
```

#### `IsOption`

``` purescript
class IsOption value where
  assoc :: forall opt. Option opt value -> value -> Options opt
```

##### Instances
``` purescript
instance isOptionString :: IsOption String
instance isOptionBoolean :: IsOption Boolean
instance isOptionNumber :: IsOption Number
instance isOptionInt :: IsOption Int
instance isOptionRecord :: IsOption {  | a }
instance isOptionUnit :: IsOption Unit
instance isOptionFunction :: IsOption (a -> b)
instance isOptionArray :: (IsOption a) => IsOption (Array a)
instance isOptionMaybe :: (IsOption a) => IsOption (Maybe a)
```

#### `(:=)`

``` purescript
(:=) :: forall opt value. (IsOption value) => Option opt value -> value -> Options opt
```

_right-associative / precedence 6_

#### `optionFn`

``` purescript
optionFn :: forall opt from to. Option opt from -> Option opt to
```

#### `key`

``` purescript
key :: forall opt value. Option opt value -> String
```

#### `opt`

``` purescript
opt :: forall opt value. (IsOption value) => String -> Option opt value
```

#### `options`

``` purescript
options :: forall a. Options a -> Foreign
```


