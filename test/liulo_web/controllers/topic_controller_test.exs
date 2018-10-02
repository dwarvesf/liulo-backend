defmodule LiuloWeb.TopicControllerTest do
  use LiuloWeb.ConnCase

  alias Liulo.Events
  alias Liulo.Events.Topic

  @create_attrs %{description: "some description", ended_at: ~N[2010-04-17 14:00:00.000000], name: "some name", speaker_names: "some speaker_names", started_at: ~N[2010-04-17 14:00:00.000000], status: 42}
  @update_attrs %{description: "some updated description", ended_at: ~N[2011-05-18 15:01:01.000000], name: "some updated name", speaker_names: "some updated speaker_names", started_at: ~N[2011-05-18 15:01:01.000000], status: 43}
  @invalid_attrs %{description: nil, ended_at: nil, name: nil, speaker_names: nil, started_at: nil, status: nil}

  def fixture(:topic) do
    {:ok, topic} = Events.create_topic(@create_attrs)
    topic
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all topic", %{conn: conn} do
      conn = get conn, topic_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create topic" do
    test "renders topic when data is valid", %{conn: conn} do
      conn = post conn, topic_path(conn, :create), topic: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, topic_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some description",
        "ended_at" => ~N[2010-04-17 14:00:00.000000],
        "name" => "some name",
        "speaker_names" => "some speaker_names",
        "started_at" => ~N[2010-04-17 14:00:00.000000],
        "status" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, topic_path(conn, :create), topic: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update topic" do
    setup [:create_topic]

    test "renders topic when data is valid", %{conn: conn, topic: %Topic{id: id} = topic} do
      conn = put conn, topic_path(conn, :update, topic), topic: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, topic_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some updated description",
        "ended_at" => ~N[2011-05-18 15:01:01.000000],
        "name" => "some updated name",
        "speaker_names" => "some updated speaker_names",
        "started_at" => ~N[2011-05-18 15:01:01.000000],
        "status" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, topic: topic} do
      conn = put conn, topic_path(conn, :update, topic), topic: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete topic" do
    setup [:create_topic]

    test "deletes chosen topic", %{conn: conn, topic: topic} do
      conn = delete conn, topic_path(conn, :delete, topic)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, topic_path(conn, :show, topic)
      end
    end
  end

  defp create_topic(_) do
    topic = fixture(:topic)
    {:ok, topic: topic}
  end
end
