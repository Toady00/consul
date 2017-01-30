defmodule Consul.Watch do
  alias Consul.HTTP.Raw
  alias Consul.KV

  defstruct index: 0,
            path: "",
            last_value: "",
            current_value: ""

  @supervisor Consul.WatchSupervisor

  def task(%KV{modify_index: 0} = kv) do
    kv
    |> KV.get
    |> task
  end
  def task(%KV{} = kv) do
    task(kv.key, kv.modify_index)
  end
  def task(path, index) do
    Task.Supervisor.async(@supervisor,
      Raw, :kv_get, [path, [index: index, recv_timeout: 300_000]]
    )
  end
end
