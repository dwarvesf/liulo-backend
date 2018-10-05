defmodule LiuloWeb.UserControllerTest do
  use LiuloWeb.ConnCase
  alias Liulo.Guardian
  alias Liulo.Accounts
  alias Liulo.Accounts.User
  import Liulo.Factory

  @create_attrs params_for(:user)
  @update_attrs params_for(:update_user)
  @invalid_attrs params_for(:invalid_user)

  def fixture(:user) do
    insert(:user)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end


  # describe "create user" do
  #   test "renders user when data is valid", %{conn: conn} do
  #     post_conn = post conn, user_path(conn, :create), user: @create_attrs
  #     assert %{"id" => id} = json_response(post_conn, 201)["data"]

  #     get_conn = get conn, user_path(conn, :show, id)
  #     assert json_response(get_conn, 200)["data"] == %{
  #       "gender" => 42,
  #       "password" => "some password",
  #       "status" => 42}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, user_path(conn, :create), user: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update user" do
  #   setup [:create_user]

  #   test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
  #     conn = put conn, user_path(conn, :update, user), user: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get conn, user_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "email" => "some updated email",
  #       "full_name" => "some updated full_name",
  #       "gender" => 43,
  #       "password" => "some updated password",
  #       "status" => 43}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, user: user} do
  #     conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete user" do
  #   setup [:create_user]

  #   test "deletes chosen user", %{conn: conn, user: user} do
  #     conn = delete conn, user_path(conn, :delete, user)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, user_path(conn, :show, user)
  #     end
  #   end
  # end

  # defp create_user(_) do
  #   user = fixture(:user)
  #   {:ok, user: user}
  # end
end
