defmodule Consul do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Task.Supervisor, [[name: Consul.WatchSupervisor]])
    ]

    opts = [strategy: :one_for_one, name: Consul.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
