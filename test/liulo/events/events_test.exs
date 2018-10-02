defmodule Liulo.EventsTest do
  use Liulo.DataCase

  alias Liulo.Events

  describe "event" do
    alias Liulo.Events.Event

    @valid_attrs %{code: "some code", description: "some description", ended_at: ~N[2010-04-17 14:00:00.000000], name: "some name", started_at: ~N[2010-04-17 14:00:00.000000], status: 42}
    @update_attrs %{code: "some updated code", description: "some updated description", ended_at: ~N[2011-05-18 15:01:01.000000], name: "some updated name", started_at: ~N[2011-05-18 15:01:01.000000], status: 43}
    @invalid_attrs %{code: nil, description: nil, ended_at: nil, name: nil, started_at: nil, status: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_event/0 returns all event" do
      event = event_fixture()
      assert Events.list_event() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.code == "some code"
      assert event.description == "some description"
      assert event.ended_at == ~N[2010-04-17 14:00:00.000000]
      assert event.name == "some name"
      assert event.started_at == ~N[2010-04-17 14:00:00.000000]
      assert event.status == 42
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Events.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.code == "some updated code"
      assert event.description == "some updated description"
      assert event.ended_at == ~N[2011-05-18 15:01:01.000000]
      assert event.name == "some updated name"
      assert event.started_at == ~N[2011-05-18 15:01:01.000000]
      assert event.status == 43
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
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

    @valid_attrs %{description: "some description", ended_at: ~N[2010-04-17 14:00:00.000000], event_id: 42, name: "some name", owner_id: 42, speaker_names: "some speaker_names", started_at: ~N[2010-04-17 14:00:00.000000], status: 42}
    @update_attrs %{description: "some updated description", ended_at: ~N[2011-05-18 15:01:01.000000], event_id: 43, name: "some updated name", owner_id: 43, speaker_names: "some updated speaker_names", started_at: ~N[2011-05-18 15:01:01.000000], status: 43}
    @invalid_attrs %{description: nil, ended_at: nil, event_id: nil, name: nil, owner_id: nil, speaker_names: nil, started_at: nil, status: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_topic()

      topic
    end

    test "list_topic/0 returns all topic" do
      topic = topic_fixture()
      assert Events.list_topic() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Events.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Events.create_topic(@valid_attrs)
      assert topic.description == "some description"
      assert topic.ended_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.event_id == 42
      assert topic.name == "some name"
      assert topic.owner_id == 42
      assert topic.speaker_names == "some speaker_names"
      assert topic.started_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.status == 42
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, topic} = Events.update_topic(topic, @update_attrs)
      assert %Topic{} = topic
      assert topic.description == "some updated description"
      assert topic.ended_at == ~N[2011-05-18 15:01:01.000000]
      assert topic.event_id == 43
      assert topic.name == "some updated name"
      assert topic.owner_id == 43
      assert topic.speaker_names == "some updated speaker_names"
      assert topic.started_at == ~N[2011-05-18 15:01:01.000000]
      assert topic.status == 43
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_topic(topic, @invalid_attrs)
      assert topic == Events.get_topic!(topic.id)
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

  describe "topic" do
    alias Liulo.Events.Topic

    @valid_attrs %{description: "some description", ended_at: ~N[2010-04-17 14:00:00.000000], name: "some name", speaker_names: "some speaker_names", started_at: ~N[2010-04-17 14:00:00.000000], status: 42}
    @update_attrs %{description: "some updated description", ended_at: ~N[2011-05-18 15:01:01.000000], name: "some updated name", speaker_names: "some updated speaker_names", started_at: ~N[2011-05-18 15:01:01.000000], status: 43}
    @invalid_attrs %{description: nil, ended_at: nil, name: nil, speaker_names: nil, started_at: nil, status: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_topic()

      topic
    end

    test "list_topic/0 returns all topic" do
      topic = topic_fixture()
      assert Events.list_topic() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Events.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Events.create_topic(@valid_attrs)
      assert topic.description == "some description"
      assert topic.ended_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.name == "some name"
      assert topic.speaker_names == "some speaker_names"
      assert topic.started_at == ~N[2010-04-17 14:00:00.000000]
      assert topic.status == 42
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, topic} = Events.update_topic(topic, @update_attrs)
      assert %Topic{} = topic
      assert topic.description == "some updated description"
      assert topic.ended_at == ~N[2011-05-18 15:01:01.000000]
      assert topic.name == "some updated name"
      assert topic.speaker_names == "some updated speaker_names"
      assert topic.started_at == ~N[2011-05-18 15:01:01.000000]
      assert topic.status == 43
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_topic(topic, @invalid_attrs)
      assert topic == Events.get_topic!(topic.id)
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
