defmodule Consul.Watch do
  @moduledoc ~S"""
  Consul provides a `blocking` query that allows you to watch for changes on
  some endpoints. These are noted in the official consul documentation.

  The default time that consul will wait before sending a response is 5 minutes.
  After that the query will return even if there hasn't been a change.

  This module is the beginning of supporting these blocking queries at a higher
  level than using the Raw client directly. `Consul.Watch` wraps the query in a
  `Task` that can be used to retrieve the value whenever it returns.

  The best way to use these tasks is probably going to be via `Task.yield/2`
  and friends. You can yield over and over again. If the query hasn't returned
  the yield will return `nil`. If the query has returned then it will return
  `{:ok, %Consul.KV{}}`. Refer to the `Task` docs for more information on
  working with `Task`s.
  """

  alias Consul.HTTP.Raw
  alias Consul.KV

  defstruct index: 0,
            path: "",
            last_value: "",
            current_value: ""

  @supervisor Consul.WatchSupervisor

  @doc ~S"""
  Create a task representing a blocking KV request.
  """
  @spec task(KV.t) :: Task.t
  def task(%KV{modify_index: 0} = kv) do
    kv
    |> KV.get
    |> task
  end
  def task(%KV{} = kv) do
    task(kv.key, kv.modify_index)
  end

  @doc ~S"""
  Create a task representing a blocking KV request.
  """
  @spec task(String.t, pos_integer) :: Task.t
  def task(path, index) do
    Task.Supervisor.async(@supervisor,
      Raw, :kv_get, [path, [index: index, recv_timeout: 300_000]]
    )
  end
end
