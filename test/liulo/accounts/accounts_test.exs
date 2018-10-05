defmodule Liulo.AccountsTest do
  use Liulo.DataCase

  alias Liulo.Accounts
  import Liulo.Factory

  describe "user" do
    alias Liulo.Accounts.User

    @valid_attrs params_for(:user)
    @update_attrs params_for(:update_user)
    @invalid_attrs params_for(:invalid_user)

    def user_fixture() do
      insert(:user)
    end

    test "list_user/0 returns all user" do
      user = user_fixture()
      assert Accounts.list_user() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "test@dwarvesv.com"
      assert user.full_name == "test full name"
      assert user.gender == :female
      assert user.password == "password"
      assert user.status == :active
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "test_update@dwarvesv.com"
      assert user.full_name == "test full name update"
      assert user.gender == :male
      assert user.password == "passwordupdate"
      assert user.status == :inactive
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
