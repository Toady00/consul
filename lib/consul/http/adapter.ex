defmodule Consul.HTTP.Adapter do
  @moduledoc false

  @callback catalog_service(String.t, list()) :: HTTPoison.Response.t
  @callback kv_delete(String.t) :: HTTPoison.Response.t
  @callback kv_get(String.t) :: HTTPoison.Response.t
  @callback kv_get(String.t, list()) :: HTTPoison.Response.t
  @callback kv_put(String.t) :: HTTPoison.Response.t
  @callback session_create(map()) :: HTTPoison.Response.t
end
