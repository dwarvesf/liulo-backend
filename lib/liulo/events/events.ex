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
    attrs =
      attrs
      |> Map.put("code", genarate_code())
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

  alias Liulo.Events.Topic

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id), do: Repo.get!(Topic, id)

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(event, owner, attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:event, event)
    |> Ecto.Changeset.put_assoc(:owner, owner)
    |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{source: %Topic{}}

  """
  def change_topic(%Topic{} = topic) do
    Topic.changeset(topic, %{})
  end

  def list_topic_by_event(%Event{} = event) do
    event = event |> Repo.preload(:topics)
    event.topics
  end

  alias Liulo.Events.Question

  @doc """
  Returns the list of question.

  ## Examples

      iex> list_question()
      [%Question{}, ...]

  """
  def list_question_by_topic(%Topic{} = topic) do
    topic = topic |> Repo.preload(:questions)
    topic.questions
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(owner, topic, attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:topic, topic)
    |> Ecto.Changeset.put_assoc(:owner, owner)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{source: %Question{}}

  """
  def change_question(%Question{} = question) do
    Question.changeset(question, %{})
  end

  alias Liulo.Events.Question

  def get_question_vote!(id), do: Repo.get!(QuestionVote, id)

  @doc """
  Creates a question_vote.

  ## Examples

      iex> create_question_vote(%{field: value})
      {:ok, %QuestionVote{}}

      iex> create_question_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  alias Liulo.Events.QuestionVote
  def create_question_vote(question, user) do
    %QuestionVote{}
    |> QuestionVote.changeset(%{})
    |> Ecto.Changeset.put_assoc(:question, question)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end
  @doc """
  Deletes a QuestionVote.

  ## Examples

      iex> delete_question_vote(question_vote)
      {:ok, %QuestionVote{}}

      iex> delete_question_vote(question_vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question_vote(question_id, user_id) do
    query = from qv in QuestionVote, where: qv.user_id == ^user_id and qv.question_id == ^question_id
    Repo.delete_all(query)
  end

end
