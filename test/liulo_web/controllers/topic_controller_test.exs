defmodule LiuloWeb.TopicControllerTest do
  use LiuloWeb.ConnCase
  alias Liulo.Guardian

  alias Liulo.Events.Topic
  import Liulo.Factory

  @create_attrs params_for(:topic)
  @update_attrs params_for(:update_topic)
  @invalid_attrs params_for(:invalid_topic)

  def fixture(:topic) do
    insert(:topic)
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
    test "lists all topic by event", %{conn: conn} do
      event = insert(:event)
      insert_list(3, :topic, event: event)
      conn = get(conn, event_topic_path(conn, :topic_by_event, event))
      data = json_response(conn, 200)["data"]
      assert Enum.count(data)
    end
  end

  describe "create topic" do
    test "renders topic when data is valid", %{conn: conn} do
      event = insert(:event)
      post_conn = post(conn, topic_path(conn, :create, %{"id" => event.id}), topic: @create_attrs)
      assert %{"id" => id} = json_response(post_conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      event = insert(:event)
      conn = post(conn, topic_path(conn, :create, %{"id" => event.id}), topic: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update topic" do
    setup [:create_topic]

    test "renders topic when data is valid", %{conn: conn, topic: %Topic{id: id} = topic} do
      put_conn = put(conn, topic_path(conn, :update, topic), topic: @update_attrs)
      assert %{"id" => ^id} = json_response(put_conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, topic: topic} do
      conn = put(conn, topic_path(conn, :update, topic), topic: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete topic" do
    setup [:create_topic]

    test "deletes chosen topic", %{conn: conn, topic: topic} do
      delete_conn = delete(conn, topic_path(conn, :delete, topic))
      assert response(delete_conn, 204)

      assert_error_sent(404, fn ->
        get(conn, topic_path(conn, :show, topic))
      end)
    end
  end

  defp create_topic(_) do
    topic = fixture(:topic)
    {:ok, topic: topic}
  end
end
