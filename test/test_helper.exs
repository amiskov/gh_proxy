# Mock is applied in test ENV via `config/test.exs`
Mox.defmock(GHProxy.MockGithubAPI, for: GHProxy.GithubAPI)
ExUnit.start()
