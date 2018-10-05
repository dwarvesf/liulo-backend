defmodule LiuloWeb.EventControllerTest do
  use LiuloWeb.ConnCase, async: true

  alias Liulo.Events
  alias Liulo.Events.Event
  alias Liulo.Guardian
  import Liulo.Factory

  @create_attrs params_for(:event)
  @update_attrs params_for(:update_event)
  @invalid_attrs params_for(:invalid_event)

  def fixture(:event) do
    insert(:event)
  end

  setup %{conn: conn} do
    user = insert(:user)
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all event", %{conn: conn} do
      conn = get conn, event_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do

      post_conn = post conn, event_path(conn, :create), event: @create_attrs
      assert %{"code" => id} = json_response(post_conn, 201)["data"]

      get_conn = get conn, event_path(conn, :show, id)
      assert json_response(get_conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      IO.inspect "-----------------------"
      IO.inspect event
      put_conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert %{"id" => ^id} = json_response(put_conn, 200)["data"]
      IO.inspect "-----------------------"
      IO.inspect id
      get_conn = get conn, event_path(conn, :show, event.code)
      assert json_response(get_conn, 200)["data"]
    end
    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      delete_conn = delete conn, event_path(conn, :delete, event)
      assert response(delete_conn, 204)
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
