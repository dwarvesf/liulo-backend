defmodule Liulo.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Liulo.Repo
  alias Liulo.Accounts.User
  alias Liulo.Events.Event
  @doc """
  Returns the list of event.

  ## Examples

      iex> list_event()
      [%Event{}, ...]

  """
  def list_event do
    Repo.all(Event)
  end
  def list_event_by_user(%User{} = user) do
    user = user |> Repo.preload(:events)
    user.events
  end
  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(owner, attrs \\ %{}) do
    attrs = attrs |> Map.put("code", genarate_code())
    %Event{}
    |> Event.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:owner, owner)
    |> Repo.insert()
  end


  defp genarate_code do
    random_code = Liulo.Utils.Randomizer.randomizer(4, :upcase)
    existed_event_by_code = Event |> Repo.get_by(code: random_code)
    check_code_unique(existed_event_by_code, random_code)
  end
  defp check_code_unique(nil, code), do:  code
  defp check_code_unique(_, _), do: genarate_code()

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end
end
