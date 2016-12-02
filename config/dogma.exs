use Mix.Config
alias Dogma.Rule

config :dogma,

  # Select a set of rules as a base
  rule_set: Dogma.RuleSet.All,

  # Pick paths not to lint
  exclude: [
    ~r(\Alib/vendor/),
    ~r(\Arel/),
    ~r(\Adeps/),
    ~r(\Abuilds/),
    ~r(\A_build/),
    ~r(\Amix.exs|test/support/model_case.ex|web/views/error_helpers.ex)
  ],

  # Override an existing rule configuration
  override: [
    %Rule.LineLength{ max_length: 120 },
    %Rule.CommentFormat{ enabled: false },
    %Rule.ModuleDoc{ enabled: false },
  ]
