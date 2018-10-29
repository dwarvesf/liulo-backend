defmodule LiuloWeb.QuestionControllerTest do
  use LiuloWeb.ConnCase
  import Liulo.Factory
  alias Liulo.Guardian

  alias Liulo.Events
  alias Liulo.Events.Question

  @create_attrs params_for(:question)
  @update_attrs params_for(:update_question)
  @invalid_attrs %{}

  # def fixture(:question) do
  #   {:ok, question} = Events.create_question(@create_attrs)
  #   question
  # end

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

    # test "renders errors when data is invalid", %{conn: conn} do
    #   topic = insert(:topic)
    #   conn = post conn, question_path(conn, :create, %{"topic_id" => topic.id}), question: @invalid_attrs
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  # describe "update question" do
  #   setup [:create_question]

  #   test "renders question when data is valid", %{conn: conn, question: %Question{id: id} = question} do
  #     conn = put conn, question_path(conn, :update, question), question: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get conn, question_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "question" => "some updated question"}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, question: question} do
  #     conn = put conn, question_path(conn, :update, question), question: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete question" do
  #   setup [:create_question]

  #   test "deletes chosen question", %{conn: conn, question: question} do
  #     conn = delete conn, question_path(conn, :delete, question)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, question_path(conn, :show, question)
  #     end
  #   end
  # end

  defp create_question(_) do
    question = insert(:question)
  end
end
