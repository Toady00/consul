defmodule Consul.KV do
  import Consul.HTTP.Response
  defstruct key:          "",
            value:        "",
            flags:        0,
            lock_index:   0,
            create_index: 0,
            modify_index: 0

  @client Application.get_env(:consul, :client, Consul.HTTP.Raw)

  def get(obj, options \\ [])
  def get(%__MODULE__{} = kv, options) do
    get(kv.path, options)
  end
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
