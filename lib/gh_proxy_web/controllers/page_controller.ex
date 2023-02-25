defmodule GHProxyWeb.PageController do
  use GHProxyWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
