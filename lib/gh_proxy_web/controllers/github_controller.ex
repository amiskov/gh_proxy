defmodule GHProxyWeb.GithubController do
  require Logger

  use GHProxyWeb, :controller

  alias GHProxy.{Cache, User}
  alias GHProxy.GithubAPI, as: GH

  def index(conn, _params) do
    render(conn, :index, layout: false)
  end

  def show(conn, %{"username" => username}) do
    case Cache.get(username) do
      {:ok, %User{} = user} ->
        render(conn, :show, user: user)

      {:ok, nil} ->
        gh_user = GH.get_user(username)
        fetch_and_render(conn, gh_user, username)
    end
  end

  defp fetch_and_render(conn, {:ok, %User{} = user}, username) do
    Cache.put(username, user)
    Logger.info("`#{username}` was cached.")
    render(conn, :show, user: user)
  end

  defp fetch_and_render(conn, {:error, msg}, username) do
    conn
    |> put_status(:not_found)
    |> render(:error, username: username, message: msg)
  end
end
