defmodule GHProxy.GithubAPI do
  alias GHProxy.User, as: User

  @callback get_user(binary()) :: {:ok, User.t()} | {:error, String.t()}

  def get_user(username), do: get_impl().get_user(username)

  # Choose the config-based implementation at compile time and use it at runtime.
  @impl_module Application.compile_env(:gh_proxy, :github, GHProxy.GithubImpl)
  def get_impl(), do: @impl_module
end

defmodule GHProxy.GithubImpl do
  require Logger

  @moduledoc "Implements GithubAPI behaviour."

  alias GHProxy.User, as: User

  @behaviour GHProxy.GithubAPI

  @impl GHProxy.GithubAPI
  def get_user(username) do
    case Tentacat.Users.find(username) do
      {200, data, _resp} ->
        {:ok,
         %User{
           username: username,
           fullname: Map.get(data, "name"),
           bio: Map.get(data, "bio"),
           url: Map.fetch!(data, "html_url"),
           avatar_url: Map.get(data, "avatar_url")
         }}

      {_code, %{"message" => msg}, _resp} = err ->
        Logger.error("#{inspect(err)}")
        {:error, msg}

      weird ->
        {:error, "Case `#{weird}` is not handled, check `Tentacat.Users.find` spec."}
    end
  end
end
