defmodule LiuloWeb.QuestionControllerTest do
  use LiuloWeb.ConnCase
  import Liulo.Factory
  alias Liulo.Guardian

  @create_attrs params_for(:question)

  setup %{conn: conn} do
    user = insert(:user)
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, conn: conn}
  end

  describe "question by topic" do
    test "lists all question by topic", %{conn: conn} do
      topic = insert(:topic)
      insert_list(3, :question, topic: topic)
      get_conn = get conn, topic_question_path(conn, :question_by_topic, topic)
      assert json_response(get_conn, 200) |> Enum.count == 3
    end
  end

  describe "create question" do
    test "renders question when data is valid", %{conn: conn} do
      topic = insert(:topic)

      post_conn = post conn, topic_question_path(conn, :create, topic.id), question: @create_attrs
      assert json_response(post_conn, 201)["data"]

    end
  end

end
