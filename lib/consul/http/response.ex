defmodule Consul.HTTP.Response do
  @moduledoc false

  def key(res),          do: extract(res, "Key")

  def value(res),        do: extract(res, "Value")

  def flags(res),        do: extract(res, "Flags")

  def create_index(res), do: extract(res, "CreateIndex")

  def lock_index(res),   do: extract(res, "LockIndex")

  def modify_index(res), do: extract(res, "ModifyIndex")

  defp extract(res, key) do
    res
    |> Map.fetch!(:body)
    |> hd
    |> Map.fetch!(key)
  end
end
