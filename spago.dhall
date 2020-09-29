{ name = "options"
, dependencies =
  [ "console"
  , "contravariant"
  , "effect"
  , "foreign"
  , "foreign-object"
  , "maybe"
  , "psci-support"
  , "spec"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
