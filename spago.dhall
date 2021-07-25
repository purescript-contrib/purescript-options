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
  , "psci-support"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
