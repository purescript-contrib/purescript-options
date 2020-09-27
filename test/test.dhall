let conf = ../spago.dhall
in conf //
  { dependencies =
      conf.dependencies #
        [ "spec" ]
  , sources =
      conf.sources #
        [ "test/**/*.purs"
        ]
  }
