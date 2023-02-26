defmodule GHProxyWeb.Router do
  use GHProxyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GHProxyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GHProxyWeb do
    pipe_through :browser

    get "/", PageController, :home
    get("/:username", GithubController, :show)
  end

  # Other scopes may use custom stacks.
  # scope "/api", GHProxyWeb do
  #   pipe_through :api
  # end
end
