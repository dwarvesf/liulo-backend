defmodule LiuloWeb.QuestionVoteControllerTest do
  use LiuloWeb.ConnCase

  alias Liulo.Events
  alias Liulo.Events.QuestionVote

  @create_attrs %{question: "some question"}
  @update_attrs %{question: "some updated question"}
  @invalid_attrs %{question: nil}

  def fixture(:question_vote) do
    {:ok, question_vote} = Events.create_question_vote(@create_attrs)
    question_vote
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all question_vote", %{conn: conn} do
      conn = get conn, question_vote_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create question_vote" do
    test "renders question_vote when data is valid", %{conn: conn} do
      conn = post conn, question_vote_path(conn, :create), question_vote: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, question_vote_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "question" => "some question"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, question_vote_path(conn, :create), question_vote: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update question_vote" do
    setup [:create_question_vote]

    test "renders question_vote when data is valid", %{conn: conn, question_vote: %QuestionVote{id: id} = question_vote} do
      conn = put conn, question_vote_path(conn, :update, question_vote), question_vote: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, question_vote_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "question" => "some updated question"}
    end

    test "renders errors when data is invalid", %{conn: conn, question_vote: question_vote} do
      conn = put conn, question_vote_path(conn, :update, question_vote), question_vote: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete question_vote" do
    setup [:create_question_vote]

    test "deletes chosen question_vote", %{conn: conn, question_vote: question_vote} do
      conn = delete conn, question_vote_path(conn, :delete, question_vote)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, question_vote_path(conn, :show, question_vote)
      end
    end
  end

  defp create_question_vote(_) do
    question_vote = fixture(:question_vote)
    {:ok, question_vote: question_vote}
  end
end
