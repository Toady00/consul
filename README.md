# Consul

[![Hex.pm](https://img.shields.io/hexpm/v/consul_client.svg)](https://hex.pm/packages/consul_client) [![build status](https://gitlab.brandondennis.me/toady00/consul/badges/master/build.svg)](https://gitlab.brandondennis.me/toady00/consul/commits/master) [![coverage report](https://gitlab.brandondennis.me/toady00/consul/badges/master/coverage.svg)](https://gitlab.brandondennis.me/toady00/consul/commits/master)

100% API Complete Consul Client written in Elixir

## Recent Changes

Higher level support for KV api and blocking queries on KV api (watching a KV for changes).
See the hex docs for now. I'll add an quick how-to to the readme soon.

Added some tests for the Raw client. Probably brittle and needs work but they
did catch some errors I hadn't noticed. They also servce as examples for how to
use some of the endpoints.

## Usage

**This package is very alpha**

```elixir
iex> alias Consul.HTTP.Raw, as: Consul
Consul.HTTP.Raw

iex> Consul.kv_get "elixir"
%HTTPoison.Response{body: [%{"CreateIndex" => 18024, "Flags" => 0,
    "Key" => "elixir", "LockIndex" => 0, "ModifyIndex" => 18024,
    "Value" => "wat"}],
 headers: [{"Content-Type", "application/json"}, {"X-Consul-Index", "18024"},
  {"X-Consul-Knownleader", "true"}, {"X-Consul-Lastcontact", "0"},
  {"Date", "Thu, 01 Dec 2016 23:33:39 GMT"}, {"Content-Length", "97"}],
 status_code: 200}

iex> Consul.kv_get "elixir", dc: "dc1"
%HTTPoison.Response{body: [%{"CreateIndex" => 18024, "Flags" => 0,
    "Key" => "elixir", "LockIndex" => 0, "ModifyIndex" => 18024,
    "Value" => "wat"}],
 headers: [{"Content-Type", "application/json"}, {"X-Consul-Index", "18024"},
  {"X-Consul-Knownleader", "true"}, {"X-Consul-Lastcontact", "0"},
  {"Date", "Thu, 01 Dec 2016 23:36:06 GMT"}, {"Content-Length", "97"}],
 status_code: 200}
```

All the functions provided are built during compile time from a map inside the
`Consul.HTTP.Raw` module. The names of the functions correspond with the http
endpoint exposed by consul. For example the endpoint `v1/acl/create` maps to a
function `Consul.HTTP.Raw.acl_create\1`. In cases where the same endpoint
accepts different HTTP verbs (get, put, post, etc.), the function name are
postfixed with the verb name. For example the endpoint `v1/kv` accepts both get
and put so there are 2 functions named `kv_get` and `kv_put`.

There are a few exceptions where the name of the function wouldn't make much
sense. If the function for `v1/session/node` was named `session_node` it may
cause some confusion, but `session_for_node` makes more sense.

Also the query endpoints fall into a wierd situation. The endpoint `v1/query`
accepts both a get and a post. So there are 2 functions named `query_get` and
`query_post`. But then there is another endpoint `v1/query/#{query_id}` that
accepts get, put, and delete. To avoid confusion, these functions are named
like `query_get_by_id`.

Every function can take an optional keyword params that get turned into url
query params. If you need to specify something like the dc to query, or pass
a consul index, this is how you would do it.

```elixir
# KV check and set example
Consul.HTTP.Raw.kv_put "elixir", "is awesome", cas: 23
```

## Endpoint -> Function mappings

|Endpoint                                   |Function|
|-------------------------------------------|---------------------------|
|v1/acl/create                              | `:acl_create`|
|v1/acl/update                              | `:acl_update`|
|v1/acl/destroy/#{id}                       | `:acl_destroy`|
|v1/acl/info/#{id}                          | `:acl_info`|
|v1/acl/clone/#{id}                         | `:acl_clone`|
|v1/acl/list                                | `:acl_list`|
|v1/acl/replication                         | `:acl_replication`|
|v1/agent/checks                            | `:agent_checks`|
|v1/agent/services                          | `:agent_services`|
|v1/agent/members                           | `:agent_members`|
|v1/agent/self                              | `:agent_self`|
|v1/agent/maintenance                       | `:agent_maintenance`|
|v1/agent/join/#{address}                   | `:agent_join`|
|v1/agent/force-leave/#{node_id}            | `:agent_force_leave`|
|v1/agent/check/register                    | `:agent_check_register`|
|v1/agent/check/deregister/#{check_id}      | `:agent_check_deregister`|
|v1/agent/check/pass/#{check_id}            | `:agent_check_pass`|
|v1/agent/check/warn/#{check_id}            | `:agent_check_warn`|
|v1/agent/check/fail/#{check_id}            | `:agent_check_fail`|
|v1/agent/check/update/#{check_id}          | `:agent_check_update`|
|v1/agent/service/register                  | `:agent_service_register`|
|v1/agent/service/deregister/#{service_id}  | `:agent_service_deregister`|
|v1/agent/service/maintenance/#{service_id} | `:agent_service_maintenance`|
|v1/catalog/register                        | `:catalog_register`|
|v1/catalog/deregister                      | `:catalog_deregister`|
|v1/catalog/datacenters                     | `:catalog_datacenters`|
|v1/catalog/nodes                           | `:catalog_nodes`|
|v1/catalog/services                        | `:catalog_services`|
|v1/catalog/services/#{service}             | `:catalog_service`|
|v1/catalog/node/#{node_id}                 | `:catalog_node`|
|v1/event/fire/#{name}                      | `:event_fire`|
|v1/event/list                              | `:event_list`|
|v1/health/node/#{node_id}                  | `:health_node`|
|v1/health/checks/#{service}                | `:health_checks`|
|v1/health/service/#{service}               | `:health_service`|
|v1/health/state/#{state}                   | `:health_state`|
|v1/kv/#{key}                               | `:kv_get`|
|v1/kv/#{key}                               | `:kv_put`|
|v1/kv/#{key}                               | `:kv_delete`|
|v1/txn                                     | `:kv_txn`|
|v1/coordinate/datacenters                  | `:coordinate_datacenters`|
|v1/coordinate/nodes                        | `:coordinate_nodes`|
|v1/operator/raft/configuration             | `:operator_raft_configuration`|
|v1/operator/raft/peer                      | `:operator_raft_peer_delete`|
|v1/operator/keyring                        | `:operator_keyring_get`|
|v1/operator/keyring                        | `:operator_keyring_put`|
|v1/operator/keyring                        | `:operator_keyring_post`|
|v1/operator/keyring                        | `:operator_keyring_delete`|
|v1/query                                   | `:query_get`|
|v1/query                                   | `:query_post`|
|v1/query/#{query}                          | `:query_get_by_id`|
|v1/query/#{query}                          | `:query_put_by_id`|
|v1/query/#{query}                          | `:query_delete_by_id`|
|v1/query/#{query}/execute                  | `:query_execute`|
|v1/query/#{query}/explain                  | `:query_explain`|
|v1/session/create                          | `:session_create`|
|v1/session/destroy/#{session}              | `:session_destroy`|
|v1/session/info/#{session}                 | `:session_info`|
|v1/session/node/#{node}                    | `:session_for_node`|
|v1/session/list                            | `:session_list`|
|v1/session/renew/#{session}                | `:session_renew`|
|v1/snapshot                                | `:snapshot_get`|
|v1/snapshot                                | `:snapshot_put`|
|v1/status/leader                           | `:status_leader`|
|v1/status/peers                            | `:status_peers`|

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `consul` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:consul, "~> 0.1.3", hex: :consul_client}]
    end
    ```

  2. Ensure `consul` is started before your application:

    ```elixir
    def application do
      [applications: [:consul]]
    end
    ```
