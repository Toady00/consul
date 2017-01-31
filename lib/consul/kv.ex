defmodule Consul.KV do
  @moduledoc ~S"""
  Higher level abstraction on top of Consul's Key Value api.
  """

  @type path    :: String.t
  @type key     :: String.t
  @type value   :: any
  @type flags   :: pos_integer
  @type index   :: pos_integer
  @type options :: keyword

  @type t :: %__MODULE__{
    key:          key,
    value:        value,
    flags:        flags,
    lock_index:   index,
    create_index: index,
    modify_index: index,
  }

  import Consul.HTTP.Response

  defstruct key:          "",
            value:        "",
            flags:        0,
            lock_index:   0,
            create_index: 0,
            modify_index: 0

  @client Application.get_env(:consul, :client, Consul.HTTP.Raw)

  def get(obj, options \\ [])

  @doc ~S"""
  Get a new `Consul.KV` struct.

  Takes either a `Consul.KV` struct with a valid `key` field or a string path.

  `options` are optional. These are the same options the `Consul.HTTP.Raw`
  client will take. They are passed through.

  ## Examples

      iex> Consul.KV.get(%Consul.KV{key: "wat"})
      %Consul.KV{}

      iex> Consul.KV.get("wat")
      %Consul.KV{}

  """
  @spec get(t, options) :: t
  def get(%__MODULE__{} = kv, options) do
    get(kv.key, options)
  end

  @spec get(path, options) :: t
  def get(path, options) do
    res = @client.kv_get(path, options)
    %__MODULE__{
      key:          key(res),
      value:        value(res),
      flags:        flags(res),
      lock_index:   lock_index(res),
      create_index: create_index(res),
      modify_index: modify_index(res)
    }
  end
end
