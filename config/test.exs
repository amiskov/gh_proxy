import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gh_proxy, GHProxyWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RmL1uR0uJB10IUCVzHhqapQoEFGuF5cyKlfU/PoJZp+UeklsER1UiGKLVAGjLrz9",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Mocking requests to GitHub API
config :gh_proxy, :github, GHProxy.MockGithubAPI

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
