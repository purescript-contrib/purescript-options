## Module Data.Options

#### `Options`

``` purescript
newtype Options opt
```

The `Options` type represents a set of options. The type argument is a
phantom type, which is useful for ensuring that options for one particular
API are not accidentally passed to some other API.

##### Instances
``` purescript
Semigroup (Options opt)
Monoid (Options opt)
```

#### `runOptions`

``` purescript
runOptions :: forall opt. Options opt -> Array (Tuple String Foreign)
```

#### `options`

``` purescript
options :: forall opt. Options opt -> Foreign
```

Convert an `Options` value into a JavaScript object, suitable for passing
to JavaScript APIs.

#### `Option`

``` purescript
type Option opt = Op (Options opt)
```

An `Option` represents an opportunity to configure a specific attribute
of a call to some API. This normally corresponds to one specific property
of an "options" object in JavaScript APIs, but can in general correspond
to zero or more actual properties.

#### `assoc`

``` purescript
assoc :: forall opt value. Option opt value -> value -> Options opt
```

Associates a value with a specific option.

#### `(:=)`

``` purescript
infixr 6 assoc as :=
```

An infix version of `assoc`.

#### `optional`

``` purescript
optional :: forall opt value. Option opt value -> Option opt (Maybe value)
```

A version of `assoc` which takes possibly absent values. `Nothing` values
are ignored; passing `Nothing` for the second argument will result in an
empty `Options`.

#### `opt`

``` purescript
opt :: forall opt value. String -> Option opt value
```

The default way of creating `Option` values. Constructs an `Option` with
the given key, which passes the given value through unchanged.

#### `tag`

``` purescript
tag :: forall opt value. Option opt value -> value -> Option opt Unit
```

Create a `tag`, by fixing an `Option` to a single value.

#### `defaultToOptions`

``` purescript
defaultToOptions :: forall opt value. String -> value -> Options opt
```

The default method for turning a string property key into an
`Option`. This function simply calls `toForeign` on the value. If
you need some other behaviour, you can write your own function to replace
this one, and construct an `Option` yourself.


