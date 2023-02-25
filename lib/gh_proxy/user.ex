defmodule GHProxy.User do
  defstruct username: "",
            fullname: nil,
            avatar_url: nil,
            url: "",
            bio: nil

  @type t :: %__MODULE__{
          username: String.t(),
          fullname: String.t() | nil,
          avatar_url: String.t() | nil,
          url: String.t(),
          bio: String.t() | nil
        }
end
