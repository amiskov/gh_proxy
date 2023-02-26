defmodule GHProxy.Cache do
  require Logger

  alias GHProxy.User, as: User

  @storage Application.compile_env!(:gh_proxy, Cache)[:cache_name]

  @spec get(k :: String.t()) :: {:ok, User.t()} | {:ok, nil}
  def get(k) do
    Cachex.get(@storage, k)
  end

  @spec put(k :: String.t(), user :: User.t()) :: {:error, bool()} | {:ok, bool()}
  def put(k, user) do
    Cachex.put(@storage, k, user)
  end
end
