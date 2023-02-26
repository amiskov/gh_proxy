defmodule GHProxyWeb.GithubControllerTest do
  use GHProxyWeb.ConnCase, async: true

  import Mox

  alias GHProxy.User, as: User

  @cached_username "john_cached"
  @not_cached_username "john_not_cached"
  @non_existing_username "john_non_existing"

  setup_all do
    GHProxy.Cache.put(@cached_username, %User{
      username: @cached_username,
      fullname: "John Cached"
    })

    :ok
  end

  setup :verify_on_exit!

  test "GET /<cached-user> will show the user", %{conn: conn} do
    conn = get(conn, ~p"/#{@cached_username}")
    {:ok, user} = GHProxy.Cache.get(@cached_username)
    assert html_response(conn, 200) =~ user.fullname
  end

  test "GET /<not-cached-user> will cache and show the user", %{conn: conn} do
    not_cached_user = %User{
      username: @not_cached_username,
      fullname: "John NotCached"
    }

    GHProxy.MockGithubAPI
    |> expect(:get_user, fn _username -> {:ok, not_cached_user} end)

    # Make sure the user is not cached before the GET request    
    assert {:ok, nil} == GHProxy.Cache.get(not_cached_user.username)
    conn = get(conn, ~p"/#{not_cached_user.username}")
    {:ok, now_cached} = GHProxy.Cache.get(@not_cached_username)
    assert html_response(conn, 200) =~ now_cached.fullname
  end

  test "GET /<non-existing-user> is not cached and not showed", %{conn: conn} do
    GHProxy.MockGithubAPI
    |> expect(:get_user, fn _ -> {:error, "not found message"} end)

    assert {:ok, nil} == GHProxy.Cache.get(@non_existing_username)
    conn = get(conn, ~p"/#{@non_existing_username}")
    assert {:ok, nil} == GHProxy.Cache.get(@non_existing_username)
    assert html_response(conn, 404) =~ "not found"
  end
end
