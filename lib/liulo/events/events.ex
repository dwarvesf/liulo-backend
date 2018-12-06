defmodule Liulo.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Liulo.Repo
  alias Liulo.Accounts.User
  alias Liulo.Events.Event
  alias Ecto.Multi

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
      |> Map.put("code", genarate_code(:event))

    %Event{}
    |> Event.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:owner, owner)
    |> Repo.insert()
  end

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

  def get_topic_by_code!(id, nil) do
    query =
      from(t in Topic,
        left_join: q in assoc(t, :questions),
        on: q.status != ^"pending",
        left_join: o in assoc(q, :owner),
        left_join: qv in assoc(q, :question_votes),
        left_join: u in assoc(qv, :user),
        on: u.id == ^1,
        where: t.code == ^id,
        order_by: [desc: q.vote_count],
        preload: [questions: {q, owner: o, question_votes: qv}]
      )

    Repo.one!(query)
  end

  def get_topic_by_code!(id, user) do
    query =
      from(t in Topic,
        left_join: q in assoc(t, :questions),
        on: q.status != ^"pending",
        left_join: o in assoc(q, :owner),
        left_join: qv in assoc(q, :question_votes),
        left_join: u in assoc(qv, :user),
        on: u.id == ^user.id,
        where: t.code == ^id,
        preload: [questions: {q, owner: o, question_votes: qv}]
      )

    Repo.one!(query)
  end

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(event, owner, attrs \\ %{}) do
    attrs =
      attrs
      |> Map.put("code", genarate_code(:topic))

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
    query = from(q in Question, where: q.topic_id == ^topic.id, order_by: [desc: q.vote_count])
    Repo.all(query)
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

  def get_question!(id, user) do
    query =
      from(q in Question,
        left_join: o in assoc(q, :owner),
        left_join: qv in assoc(q, :question_votes),
        left_join: u in assoc(qv, :user),
        on: u.id == ^user.id,
        where: q.id == ^id,
        preload: [owner: o, question_votes: qv]
      )

    Repo.one!(query)
  end

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
    Multi.new()
    |> Multi.insert(
      :question_vote,
      QuestionVote.changeset(%QuestionVote{}, %{})
      |> Ecto.Changeset.put_assoc(:question, question)
      |> Ecto.Changeset.put_assoc(:user, user)
    )
    |> Multi.run(:update_number_of_vote, fn _ ->
      update_number_of_vote_for_question(question)
    end)
    |> Repo.transaction()
  end

  @doc """
  Deletes a QuestionVote.

  ## Examples

      iex> delete_question_vote(question_vote)
      {:ok, %QuestionVote{}}

      iex> delete_question_vote(question_vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question_vote(question, user_id) do
    Multi.new()
    |> Multi.delete_all(
      :question_votes,
      from(qv in QuestionVote, where: qv.user_id == ^user_id and qv.question_id == ^question.id)
    )
    |> Multi.run(:update_question_vote, fn _ ->
      update_number_of_vote_for_question(question)
    end)
    |> Repo.transaction()
  end

  defp update_number_of_vote_for_question(question) do
    query = from(qv in QuestionVote, where: qv.question_id == ^question.id)
    count = Repo.aggregate(query, :count, :question_id)
    update_question(question, %{vote_count: count})
  end

  defp genarate_code(type) do
    random_code = Liulo.Utils.Randomizer.randomizer(4, :upcase)

    object =
      case type do
        :topic -> Topic |> Repo.get_by(code: random_code)
        _ -> Event |> Repo.get_by(code: random_code)
      end

    check_code_unique(object, type, random_code)
  end

  defp check_code_unique(nil, _type, code), do: code
  defp check_code_unique(_, type, _), do: genarate_code(type)
end
