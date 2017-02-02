defmodule Consul.HTTP.RawTest do
  use ExUnit.Case
  alias Consul.HTTP.Raw

  describe "agent" do
    test "checks endpoint returns 200" do
      assert Raw.agent_checks.status_code == 200
    end

    test "services endpoint returns 200" do
      assert Raw.agent_services.status_code == 200
    end

    test " members endpoint returns 200" do
      assert Raw.agent_members.status_code == 200
    end

    test "self endpoint returns 200" do
      assert Raw.agent_self.status_code == 200
    end

    test "maintenance endpoint returns 200" do
      response = Raw.agent_maintenance "", enable: true
      assert response.status_code == 200
      response = Raw.agent_maintenance "", enable: false
      assert response.status_code == 200
    end

    test "join endpoint returns 200" do
      assert Raw.agent_join("127.0.0.1").status_code == 200
    end

    @tag :pending
    test "force-leave endpoint returns 200"
    @tag :pending
    test "leave endpoint returns 200"

    test "check register endpoint returns 200" do
      assert Raw.agent_check_register(%{name: "test_check", ttl: "15s"}).status_code == 200
      assert Raw.agent_check_deregister("test_check").status_code == 200
    end

    test "check pass endpoint returns 200" do
      Raw.agent_check_register(%{name: "test_check", ttl: "15s"})
      assert Raw.agent_check_pass("test_check").status_code == 200
      Raw.agent_check_deregister("test_check")
    end

    test "check warn endpoint returns 200" do
      Raw.agent_check_register(%{name: "test_check", ttl: "15s"})
      assert Raw.agent_check_warn("test_check").status_code == 200
      Raw.agent_check_deregister("test_check")
    end

    test "check fail endpoint returns 200" do
      Raw.agent_check_register(%{name: "test_check", ttl: "15s"})
      assert Raw.agent_check_fail("test_check").status_code == 200
      Raw.agent_check_deregister("test_check")
    end

    test "check update endpoint returns 200" do
      Raw.agent_check_register(%{name: "test_check", ttl: "15s"})
      assert Raw.agent_check_update("test_check", %{status: "passing"}).status_code == 200
      Raw.agent_check_deregister("test_check")
    end

    test "service register endpoint returns 200" do
      assert Raw.agent_service_register(%{name: "test_service"}).status_code == 200
      assert Raw.agent_service_deregister("test_service").status_code == 200
    end

    test "service maintenance endpoint returns 200" do
      Raw.agent_service_register(%{name: "test_service"})
      assert Raw.agent_service_maintenance("test_service", "", enable: true).status_code == 200
      Raw.agent_service_deregister("test_service")
    end
  end

  describe "catalog" do
    test "register endpoint returns 200" do
      assert Raw.catalog_register(%{node: "another", address: "127.0.0.1"}).status_code == 200
      assert Raw.catalog_deregister(%{node: "another"}).status_code == 200
    end

    test "datacenters endpoint returns 200" do
      assert Raw.catalog_datacenters.status_code == 200
    end

    test "nodes endpoint returns 200" do
      assert Raw.catalog_nodes.status_code == 200
    end

    test "services endpoint returns 200" do
      assert Raw.catalog_services.status_code == 200
    end

    @tag :pending #TODO: Figure out why this isn't working
    test "service endpoint returns 200" do
      Raw.agent_service_register(%{name: "test_service"})
      assert Raw.catalog_service("test_service").status_code == 200
      Raw.agent_service_deregister("test_service")
    end

    test "node endpoint returns 200" do
      node = Raw.catalog_nodes.body
      |> hd
      |> Map.fetch!("Node")
      assert Raw.catalog_node(node).status_code == 200
    end
  end

  describe "event" do
    test "fire endpoint returns 200" do
      assert Raw.event_fire("my-event").status_code == 200
    end

    test "list endpoint returns 200" do
      assert Raw.event_list.status_code == 200
    end
  end
end
