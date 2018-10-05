defmodule Liulo.EventsTest do
  use Liulo.DataCase

  alias Liulo.Events

  import Liulo.Factory

  describe "event" do
    alias Liulo.Events.Event

    @valid_attrs params_for(:event)
    @update_attrs %{code: "some updated code", description: "some updated description", ended_at: ~N[2011-05-18 15:01:01.000000], name: "some updated name", started_at: ~N[2011-05-18 15:01:01.000000], status: 43}
    @invalid_attrs %{code: nil, description: nil, ended_at: nil, name: nil, started_at: nil, status: nil}

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
      assert {:ok, %Event{} = event} = Events.create_event(owner, params_for(:event))
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

      assert {:ok, %Topic{} = topic} = Events.create_topic(event, owner, @valid_attrs)
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
      assert {:error, %Ecto.Changeset{}} = Events.create_topic(event, owner, @invalid_attrs)
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
end
