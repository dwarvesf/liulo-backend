defmodule LiuloWeb.QuestionVoteControllerTest do
  use LiuloWeb.ConnCase
  import Liulo.Factory
  alias Liulo.Guardian

  setup %{conn: conn} do
    user = insert(:user)
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, conn: conn}
  end

  describe "up_vote" do
    test "render upvote is valid", %{conn: conn} do
      question = insert(:question)
      topic = insert(:topic)
      conn = post conn, topic_question_question_vote_path(conn, :create, topic.id, question.id)
      assert %{} = json_response(conn, 200)["data"]
    end


  end

#   describe "delete question_vote" do
#     test "deletes chosen question_vote", %{conn: conn} do
#       question = insert(:question)
#       topic = insert(:topic)

#       post_conn = post conn, topic_question_question_vote_path(conn, :create, topic.id, question.id)
#       assert %{} = json_response(post_conn, 200)["data"]
#       delete_conn = delete conn, topic_question_question_vote_path(conn, :delete, :create, topic.id, question.id)
#       assert response(delete_conn, 204)
# end
  end
end
