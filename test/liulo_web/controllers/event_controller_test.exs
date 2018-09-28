defmodule LiuloWeb.EventControllerTest do
  use LiuloWeb.ConnCase

  alias Liulo.Events
  alias Liulo.Events.Event

  @create_attrs %{code: "some code", description: "some description", ended_at: ~N[2010-04-17 14:00:00.000000], name: "some name", started_at: ~N[2010-04-17 14:00:00.000000], status: 42}
  @update_attrs %{code: "some updated code", description: "some updated description", ended_at: ~N[2011-05-18 15:01:01.000000], name: "some updated name", started_at: ~N[2011-05-18 15:01:01.000000], status: 43}
  @invalid_attrs %{code: nil, description: nil, ended_at: nil, name: nil, started_at: nil, status: nil}

  def fixture(:event) do
    {:ok, event} = Events.create_event(@create_attrs)
    event
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all event", %{conn: conn} do
      conn = get conn, event_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "code" => "some code",
        "description" => "some description",
        "ended_at" => ~N[2010-04-17 14:00:00.000000],
        "name" => "some name",
        "started_at" => ~N[2010-04-17 14:00:00.000000],
        "status" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "code" => "some updated code",
        "description" => "some updated description",
        "ended_at" => ~N[2011-05-18 15:01:01.000000],
        "name" => "some updated name",
        "started_at" => ~N[2011-05-18 15:01:01.000000],
        "status" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, event_path(conn, :delete, event)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end
end
