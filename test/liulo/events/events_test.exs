defmodule Liulo.EventsTest do
  use Liulo.DataCase

  alias Liulo.Events
  alias Liulo.TestHelper

  import Liulo.Factory

  describe "event" do
    alias Liulo.Events.Event

    @valid_attrs params_for(:event) |> Liulo.TestHelper.stringify_keys()
    @invalid_attrs %{
      code: nil,
      description: nil,
      ended_at: nil,
      name: nil,
      started_at: nil,
      status: nil
    }

    def event_fixture(attrs \\ %{}) do
      insert(:event, attrs)
    end

    test "list_event_by_user/0 returns all event" do
      user = insert(:user)
      event = event_fixture(owner: user) |> Unpreloader.forget(:owner)
      assert Events.list_event_by_user(user) == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture() |> Unpreloader.forget(:owner)
      assert Events.get_event!(event.id) == event
    end

    test "create_event/2 with valid data creates a event" do
      owner = insert(:user)
      assert {:ok, %Event{} = event} = Events.create_event(owner, @valid_attrs)
      assert event.description == "Event test description"
      assert event.ended_at == ~N[2010-04-17 14:00:00.000000]
      assert event.name == "Event test"
      assert event.started_at == ~N[2010-04-17 14:00:00.000000]
      assert event.status == :active
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      assert {:ok, event} = Events.update_event(event, params_for(:update_event))
      assert %Event{} = event
      assert event.description == "Update"
      assert event.name == "Update"
      assert event.status == :active
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, params_for(:invalid_event))

      assert event |> Unpreloader.forget(:owner) == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end

  describe "topic" do
    alias Liulo.Events.Topic

    @valid_attrs params_for(:topic)
    @update_attrs params_for(:update_topic)
    @invalid_attrs params_for(:invalid_topic)

    def topic_fixture(attrs \\ %{}) do
      insert(:topic, attrs)
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Events.get_topic!(topic.id) == topic |> Unpreloader.forget(:event)
    end

    test "create_topic/3 with valid data creates a topic" do
      owner = insert(:user)
      event = event_fixture(owner: owner) |> Unpreloader.forget(:owner)

      assert {:ok, %Topic{} = topic} =
               Events.create_topic(event, owner, TestHelper.stringify_keys(@valid_attrs))

      assert topic.description == "topic test description"
      assert topic.ended_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.name == "topic name"
      assert topic.speaker_names == "topic speaker_names"
      assert topic.started_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.status == :active
    end

    test "create_topic/3 with invalid data returns error changeset" do
      owner = insert(:user)
      event = event_fixture(owner: owner) |> Unpreloader.forget(:owner)

      assert {:error, %Ecto.Changeset{}} =
               Events.create_topic(event, owner, TestHelper.stringify_keys(@invalid_attrs))
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, topic} = Events.update_topic(topic, @update_attrs)
      assert %Topic{} = topic
      assert topic.description == "update topic test description"
      assert topic.ended_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.name == "update topic name"
      assert topic.speaker_names == "update topic speaker_names"
      assert topic.started_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.status == :active
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_topic(topic, @invalid_attrs)
      assert topic |> Unpreloader.forget(:event) == Events.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Events.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Events.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Events.change_topic(topic)
    end
  end

  describe "question" do
    alias Liulo.Events.Question

    @valid_attrs params_for(:question)
    @update_attrs params_for(:update_question)
    @invalid_attrs params_for(:invalid_question)

    def question_fixture(attrs \\ %{}) do
      insert(:question, attrs)
    end

    test "list_question/0 returns all question" do
      topic = topic_fixture()

      question =
        question_fixture(topic: topic) |> Unpreloader.forget(:topic) |> Unpreloader.forget(:owner)

      assert Events.list_question_by_topic(topic) == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Events.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      # owner
      user = insert(:user)
      # topic
      topic = topic_fixture()

      assert {:ok, %Question{} = question} = Events.create_question(user, topic, @valid_attrs)
      assert question.description == "question description"
      assert question.is_anonymous == true
      assert question.status == :pending
      assert question.vote_count == 0
    end

    test "create_question/1 with invalid data returns error changeset" do
      # owner
      user = insert(:user)
      # topic
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.create_question(user, topic, @invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, question} = Events.update_question(question, @update_attrs)
      assert question.description == "update question description"
      assert question.is_anonymous == true
      assert question.status == :answered
      assert question.vote_count == 1
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_question(question, @invalid_attrs)
      assert question == Events.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Events.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Events.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Events.change_question(question)
    end
  end

  describe "question_vote" do
    @valid_attrs %{}

    def question_vote_fixture(attrs \\ %{}) do
      {:ok, question_vote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_question_vote()

      question_vote
    end

    test "create_question_vote/1 with valid data creates a question_vote" do
      question = question_fixture()
      user = insert(:user)
      assert {:ok, question_vote} = Events.create_question_vote(question, user)
    end

    test "delete_question_vote/1 deletes the question_vote" do
      question = question_fixture()
      user = insert(:user)
      Events.create_question_vote(question, user)
      assert {:ok, _} = Events.delete_question_vote(question, user.id)
    end
  end
end
