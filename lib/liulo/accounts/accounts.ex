defmodule Liulo.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Liulo.Repo
  alias Ecto.Multi

  alias Liulo.Accounts.User

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]

  """
  def list_user do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Liulo.Accounts.ExternalProviderUser

  @doc """
  Returns the list of external_provider_user.

  ## Examples

      iex> list_external_provider_user()
      [%ExternalProviderUser{}, ...]

  """
  def list_external_provider_user do
    Repo.all(ExternalProviderUser)
  end

  @doc """
  Gets a single external_provider_user.

  Raises `Ecto.NoResultsError` if the External provider user does not exist.

  ## Examples

      iex> get_external_provider_user!(123)
      %ExternalProviderUser{}

      iex> get_external_provider_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_external_provider_user!(id), do: Repo.get!(ExternalProviderUser, id)

  @doc """
  Creates a external_provider_user.

  ## Examples

      iex> create_external_provider_user(%{field: value})
      {:ok, %ExternalProviderUser{}}

      iex> create_external_provider_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_external_provider_user(attrs \\ %{}) do
    %ExternalProviderUser{}
    |> ExternalProviderUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a external_provider_user.

  ## Examples

      iex> update_external_provider_user(external_provider_user, %{field: new_value})
      {:ok, %ExternalProviderUser{}}

      iex> update_external_provider_user(external_provider_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_external_provider_user(%ExternalProviderUser{} = external_provider_user, attrs) do
    external_provider_user
    |> ExternalProviderUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ExternalProviderUser.

  ## Examples

      iex> delete_external_provider_user(external_provider_user)
      {:ok, %ExternalProviderUser{}}

      iex> delete_external_provider_user(external_provider_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_external_provider_user(%ExternalProviderUser{} = external_provider_user) do
    Repo.delete(external_provider_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking external_provider_user changes.

  ## Examples

      iex> change_external_provider_user(external_provider_user)
      %Ecto.Changeset{source: %ExternalProviderUser{}}

  """
  def change_external_provider_user(%ExternalProviderUser{} = external_provider_user) do
    ExternalProviderUser.changeset(external_provider_user, %{})
  end

  def get_user_by_provider("google", google_user) do
    ExternalProviderUser
    |> Repo.get_by(provider_type: :google, provider_user_id: google_user.email)
    |> get_user_by_external_provider_user(google_user)
  end

  def get_user_by_external_provider_user(nil, google_user) do
    Multi.new()
    |> Multi.insert(
      :user,
      User.changeset(%User{}, %{
        email: google_user.email,
        full_name: google_user.name
      })
    )
    |> Multi.run(:external_user_provider, fn %{user: user} ->
      ExternalProviderUser.changeset(%ExternalProviderUser{}, %{
        provider_user_id: google_user.email,
        token: google_user.access_token,
        data: Map.from_struct(google_user)
      })
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> user
      error -> error
    end
  end

  def get_user_by_external_provider_user(%ExternalProviderUser{} = provider_user, _) do
    provider_user = provider_user |> Repo.preload(:user)
    provider_user.user
  end
end
