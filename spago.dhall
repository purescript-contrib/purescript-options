{ name = "options"
, dependencies =
  [ "console"
  , "contravariant"
  , "effect"
  , "foreign"
  , "foreign-object"
  , "maybe"
  , "psci-support"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
