{ name = "options"
, dependencies =
  [ "assert"
  , "console"
  , "contravariant"
  , "effect"
  , "foreign"
  , "foreign-object"
  , "maybe"
  , "newtype"
  , "prelude"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
