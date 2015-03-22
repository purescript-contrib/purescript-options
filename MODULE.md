# Module Documentation

## Module Data.Options

#### `Options`

``` purescript
data Options :: * -> *
```


#### `Option`

``` purescript
data Option :: * -> * -> *
```


#### `IsOption`

``` purescript
class IsOption r where
  (:=) :: forall a. Option a r -> r -> Options a
```


#### `optionFn`

``` purescript
optionFn :: forall r s a. Option a r -> Option a s
```


#### `semigroupOptions`

``` purescript
instance semigroupOptions :: Semigroup (Options a)
```


#### `monoidOptions`

``` purescript
instance monoidOptions :: Monoid (Options a)
```


#### `isOptionString`

``` purescript
instance isOptionString :: IsOption String
```


#### `isOptionBoolean`

``` purescript
instance isOptionBoolean :: IsOption Boolean
```


#### `isOptionNumber`

``` purescript
instance isOptionNumber :: IsOption Number
```


#### `isOptionRecord`

``` purescript
instance isOptionRecord :: IsOption {  | a }
```


#### `isOptionFunction`

``` purescript
instance isOptionFunction :: IsOption (a -> b)
```


#### `isOptionArray`

``` purescript
instance isOptionArray :: (IsOption a) => IsOption [a]
```


#### `isOptionMaybe`

``` purescript
instance isOptionMaybe :: (IsOption a) => IsOption (Maybe a)
```


#### `options`

``` purescript
options :: forall a. Options a -> Foreign
```


#### `opt`

``` purescript
opt :: forall k v. (IsOption v) => String -> Option k v
```




