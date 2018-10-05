defmodule Liulo.Factory do
  use ExMachina.Ecto, repo: Liulo.Repo
  #User
  alias Liulo.Accounts.User

  def user_factory do
    %User{email: "test@dwarvesv.com",
    full_name: "test full name",
    gender: :female,
    password: "password",
    status: :active
    }
  end

  def update_user_factory do
    %User{email: "test_update@dwarvesv.com",
    full_name: "test full name update",
    gender: :male,
    password: "passwordupdate",
    status: :inactive}
  end

  def invalid_user_factory do
    %User{email: ""}
  end

  #Event
  alias Liulo.Events.Event
  def event_factory do
    %Event{
      code: "ABCD",
      description: "Event test description",
      ended_at: ~N[2010-04-17 14:00:00.000000],
      name: "Event test",
      started_at: ~N[2010-04-17 14:00:00.000000],
      status: :active,
      owner: build(:user)
    }
  end

  def update_event_factory do
    %Event{
      description: "Update",
      ended_at: ~N[2010-04-17 14:00:00.000000],
      name: "Update",
      started_at: ~N[2010-04-17 14:00:00.000000],
      status: :active
    }
  end
  def invalid_event_factory do
    %Event{
      name: ""
    }
  end
  alias Liulo.Events.Topic
  #Topic
  def topic_factory do
    %Topic {
      description: "topic test description",
      ended_at: ~N[2010-04-17 14:00:00.000000],
      name: "topic name",
      speaker_names: "topic speaker_names",
      started_at: ~N[2010-04-17 14:00:00.000000],
      status: :active,
      event: build(:event)
    }
  end
  def update_topic_factory do
    %Topic {
      description: "update topic test description",
      ended_at: ~N[2010-04-17 14:00:00.000000],
      name: "update topic name",
      speaker_names: "update topic speaker_names",
      started_at: ~N[2010-04-17 14:00:00.000000],
      status: :active
    }
  end
  def invalid_topic_factory do
    %Topic {
      name: ""
    }
  end

end
