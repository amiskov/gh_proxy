Mox.defmock(GHProxy.MockGithubAPI, for: GHProxy.GithubAPI)
Application.put_env(:gh_proxy, :github, GHProxy.MockGithubAPI)
ExUnit.start()
