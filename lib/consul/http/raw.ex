defmodule Consul.HTTP.Raw do
  endpoints = %{
    v1: [
      # ACL
      %{
        path: ["v1", "acl", "create"],
        name: :acl_create,
        method: :put
      },
      %{
        path: ["v1", "acl", "update"],
        name: :acl_update,
        method: :put
      },
      %{
        path: ["v1", "acl", "destroy", {:var, :id}],
        name: :acl_destroy,
        args: [:id],
        method: :put
      },
      %{
        path: ["v1", "acl", "info", {:var, :id}],
        name: :acl_info,
        args: [:id],
        method: :get
      },
      %{
        path: ["v1", "acl", "clone", {:var, :id}],
        name: :acl_clone,
        args: [:id],
        method: :put
      },
      %{
        path: ["v1", "acl", "list"],
        name: :acl_list,
        method: :put
      },
      %{
        path: ["v1", "acl", "replication"],
        name: :acl_replication,
        method: :get
      },
      # Agent
      %{
        path: ["v1", "agent", "checks"],
        name: :agent_checks,
        method: :get
      },
      %{
        path: ["v1", "agent", "services"],
        name: :agent_services,
        method: :get
      },
      %{
        path: ["v1", "agent", "members"],
        name: :agent_members,
        method: :get
      },
      %{
        path: ["v1", "agent", "self"],
        name: :agent_self,
        method: :get
      },
      %{
        path: ["v1", "agent", "maintenance"],
        name: :agent_maintenance,
        method: :put
      },
      %{
        path: ["v1", "agent", "join", {:var, :address}],
        name: :agent_join,
        args: [:address],
        method: :get
      },
      %{
        path: ["v1", "agent", "force-leave", {:var, :node_id}],
        name: :agent_force_leave,
        args: [:node_id],
        method: :get
      },
      %{
        path: ["v1", "agent", "check", "register"],
        name: :agent_check_register,
        method: :put
      },
      %{
        path: ["v1", "agent", "check", "deregister", {:var, :check_id}],
        name: :agent_check_deregister,
        args: [:check_id],
        method: :get
      },
      %{
        path: ["v1", "agent", "check", "pass", {:var, :check_id}],
        name: :agent_check_pass,
        args: [:check_id],
        method: :get
      },
      %{
        path: ["v1", "agent", "check", "warn", {:var, :check_id}],
        name: :agent_check_warn,
        args: [:check_id],
        method: :get
      },
      %{
        path: ["v1", "agent", "check", "fail", {:var, :check_id}],
        name: :agent_check_fail,
        args: [:check_id],
        method: :get
      },
      %{
        path: ["v1", "agent", "check", "update", {:var, :check_id}],
        name: :agent_check_update,
        args: [:check_id],
        method: :put
      },
      %{
        path: ["v1", "agent", "service", "register"],
        name: :agent_service_register,
        method: :put
      },
      %{
        path: ["v1", "agent", "service", "deregister", {:var, :service_id}],
        name: :agent_service_deregister,
        args: [:service_id],
        method: :put
      },
      %{
        path: ["v1", "agent", "service", "maintenance", {:var, :service_id}],
        name: :agent_service_maintenance,
        args: [:service_id],
        method: :put
      },
      # Catalog
      %{
        path: ["v1", "catalog", "register"],
        name: :catalog_register,
        method: :put
      },
      %{
        path: ["v1", "catalog", "deregister"],
        name: :catalog_deregister,
        method: :put
      },
      %{
        path: ["v1", "catalog", "datacenters"],
        name: :catalog_datacenters,
        method: :get
      },
      %{
        path: ["v1", "catalog", "nodes"],
        name: :catalog_nodes,
        method: :get
      },
      %{
        path: ["v1", "catalog", "services"],
        name: :catalog_services,
        method: :get
      },
      %{
        path: ["v1", "catalog", "service", {:var, :service}],
        args: [:service],
        name: :catalog_service,
        method: :get
      },
      %{
        path: ["v1", "catalog", "node", {:var, :node_id}],
        args: [:node_id],
        name: :catalog_node,
        method: :get
      },
      # Event
      %{
        path: ["v1", "event", "fire", {:var, :name}],
        name: :event_fire,
        args: [:name],
        method: :put
      },
      %{
        path: ["v1", "event", "list"],
        name: :event_list,
        method: :get
      },
      # Health
      %{
        path: ["v1", "health", "node", {:var, :node_id}],
        name: :health_node,
        args: [:node_id],
        method: :get
      },
      %{
        path: ["v1", "health", "checks", {:var, :service}],
        name: :health_checks,
        args: [:service],
        method: :get
      },
      %{
        path: ["v1", "health", "service", {:var, :service}],
        name: :health_service,
        args: [:service],
        method: :get
      },
      %{
        path: ["v1", "health", "state", {:var, :state}],
        name: :health_state,
        args: [:state],
        method: :get
      },
      #KV
      %{
        # path: quote do "v1/kv/#{unquote({:key, [], Elixir})}" end,
        path: ["v1", "kv", {:var, :key}],
        # path: ["v1/kv/", {:var, :key}],
        name: :kv_get,
        args: [:key],
        method: :get
      },
      # TODO: maybe seperate path args from args
      %{
        path: ["v1", "kv", {:var, :key}],
        name: :kv_put,
        args: [:key],
        method: :put
      },
      %{
        path: ["v1", "kv", {:var, :key}],
        name: :kv_delete,
        args: [:key],
        method: :delete
      },
      %{
        path: ["v1", "txn"],
        name: :kv_txn,
        method: :put
      },
      # Coordinate
      %{
        path: ["v1", "coordinate", "datacenters"],
        name: :coordinate_datacenters,
        method: :get
      },
      %{
        path: ["v1", "coordinate", "nodes"],
        name: :coordinate_nodes,
        method: :get
      },
      # Operator
      %{
        path: ["v1", "operator", "raft", "configuration"],
        name: :operator_raft_configuration,
        method: :get
      },
      %{
        path: ["v1", "operator", "raft", "peer"],
        name: :operator_raft_peer_delete,
        method: :delete
      },
      %{
        path: ["v1", "operator", "keyring"],
        name: :operator_keyring_get,
        method: :get
      },
      %{
        path: ["v1", "operator", "keyring"],
        name: :operator_keyring_put,
        method: :put
      },
      %{
        path: ["v1", "operator", "keyring"],
        name: :operator_keyring_post,
        method: :post
      },
      %{
        path: ["v1", "operator", "keyring"],
        name: :operator_keyring_delete,
        method: :delete
      },
      # Query
      %{
        path: ["v1", "query"],
        name: :query_get,
        method: :get
      },
      %{
        path: ["v1", "query"],
        name: :query_post,
        method: :post
      },
      %{
        path: ["v1", "query", {:var, :query}],
        args: [:query],
        name: :query_get_by_id,
        method: :get
      },
      %{
        path: ["v1", "query", {:var, :query}],
        args: [:query],
        name: :query_put_by_id,
        method: :put
      },
      %{
        path: ["v1", "query", {:var, :query}],
        args: [:query],
        name: :query_delete_by_id,
        method: :delete
      },
      %{
        path: ["v1", "query", {:var, :query}, "execute"],
        args: [:query],
        name: :query_execute,
        method: :get
      },
      %{
        path: ["v1", "query", {:var, :query}, "explain"],
        args: [:query],
        name: :query_explain,
        method: :get
      },
      # Session
      %{
        path: ["v1", "session", "create"],
        name: :session_create,
        method: :put
      },
      %{
        path: ["v1", "session", "destroy", {:var, :session}],
        args: [:session],
        name: :session_destroy,
        method: :put
      },
      %{
        path: ["v1", "session", "info", {:var, :session}],
        args: [:session],
        name: :session_info,
        method: :get
      },
      %{
        path: ["v1", "session", "node", {:var, :node}],
        args: [:node],
        name: :session_for_node,
        method: :get
      },
      %{
        path: ["v1", "session", "list"],
        name: :session_list,
        method: :get
      },
      %{
        path: ["v1", "session", "renew", {:var, :session}],
        args: [:session],
        name: :session_renew,
        method: :put
      },
      # Snapshot
      %{
        path: ["v1", "snapshot"],
        name: :snapshot_get,
        method: :get
      },
      %{
        path: ["v1", "snapshot"],
        name: :snapshot_put,
        method: :put
      },
      # Status
      %{
        path: ["v1", "status", "leader"],
        name: :status_leader,
        method: :get
      },
      %{
        path: ["v1", "status", "peers"],
        name: :status_peers,
        method: :get
      }
    ]
  }

  path_segment_to_macro = fn
    segment when is_binary(segment) -> segment
    {:var, var} -> Macro.var(var, __MODULE__)
  end

  join_segments = fn(first, second) ->
    if second == nil do
      first
    else
      quote do: unquote(second) <> "/" <> unquote(first)
    end
  end

  path_segments_to_macro = fn(segments) ->
    segments
    |> Enum.map(&(path_segment_to_macro.(&1)))
    |> Enum.reduce(nil, &(join_segments.(&1, &2)))
  end

  http_option_keys = [:timeout,
                      :recv_timeout,
                      :stream_to,
                      :async,
                      :proxy,
                      :proxy_auth,
                      :ssl,
                      :follow_redirect,
                      :max_redirect]

  endpoints = endpoints.v1
  Enum.each(endpoints, fn(endpoint) ->
    case endpoint do
      %{path: path, name: name, method: :get, args: args} ->
        joined_args = Enum.map(args, &({&1, [], __MODULE__}))
        def unquote(name)(unquote_splicing(joined_args), params \\ []) do
          {http_options, params} = Keyword.split(params, unquote(http_option_keys))
          options = Keyword.put(http_options, :params, params)
          apply(Consul.HTTP.Client, unquote(:"get!"), [unquote(path_segments_to_macro.(path)), [], options])
        end
      %{path: path, name: name, method: :get} ->
        def unquote(name)(params \\ []) do
          {http_options, params} = Keyword.split(params, unquote(http_option_keys))
          options = Keyword.put(http_options, :params, params)
          apply(Consul.HTTP.Client, unquote(:"get!"), [unquote(path_segments_to_macro.(path)), [], options])
        end
      %{path: path, name: name, method: :delete, args: args} ->
        joined_args = Enum.map(args, &({&1, [], __MODULE__}))
        def unquote(name)(unquote_splicing(joined_args), params \\ []) do
          {http_options, params} = Keyword.split(params, unquote(http_option_keys))
          options = Keyword.put(http_options, :params, params)
          apply(Consul.HTTP.Client, unquote(:"delete!"), [unquote(path_segments_to_macro.(path)), [], options])
        end
      %{path: path, name: name, method: :delete} ->
        def unquote(name)(params \\ []) do
          {http_options, params} = Keyword.split(params, unquote(http_option_keys))
          options = Keyword.put(http_options, :params, params)
          apply(Consul.HTTP.Client, unquote(:"delete!"), [unquote(path_segments_to_macro.(path)), [], options])
        end
      %{path: path, name: name, method: :put, args: args} ->
        joined_args = Enum.map(args, &({&1, [], __MODULE__}))
        def unquote(name)(unquote_splicing(joined_args), data \\ "", params \\ []) do
          {http_options, params} = Keyword.split(params, unquote(http_option_keys))
          options = Keyword.put(http_options, :params, params)
          apply(Consul.HTTP.Client, unquote(:"put!"), [unquote(path_segments_to_macro.(path)), data, [], options])
        end
      %{path: path, name: name, method: :put} ->
        def unquote(name)(data, params \\ []) do
          {http_options, params} = Keyword.split(params, unquote(http_option_keys))
          options = Keyword.put(http_options, :params, params)
          apply(Consul.HTTP.Client, unquote(:"put!"), [unquote(path_segments_to_macro.(path)), data, [], options])
        end
      %{path: path, name: name, method: :post, args: args} ->
        joined_args = Enum.map(args, &({&1, [], __MODULE__}))
        def unquote(name)(data, unquote_splicing(joined_args), params \\ []) do
          {http_options, params} = Keyword.split(params, unquote(http_option_keys))
          options = Keyword.put(http_options, :params, params)
          apply(Consul.HTTP.Client, unquote(:"post!"), [unquote(path_segments_to_macro.(path)), data, [], options])
        end
      %{path: path, name: name, method: :post} ->
        def unquote(name)(data, params \\ []) do
          {http_options, params} = Keyword.split(params, unquote(http_option_keys))
          options = Keyword.put(http_options, :params, params)
          apply(Consul.HTTP.Client, unquote(:"post!"), [unquote(path_segments_to_macro.(path)), data, [], options])
        end
    end
  end)
end
