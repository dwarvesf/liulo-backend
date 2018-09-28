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
end
