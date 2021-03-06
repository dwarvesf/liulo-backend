defmodule Liulo.Factory do
  use ExMachina.Ecto, repo: Liulo.Repo
  # User
  alias Liulo.Accounts.User
  alias Liulo.Events.Question
  alias Liulo.Events.Question_Vote

  def user_factory do
    %User{
      email: "test@dwarvesv.com",
      full_name: "test full name",
      gender: :female,
      password: "password",
      status: :active
    }
  end

  def update_user_factory do
    %User{
      email: "test_update@dwarvesv.com",
      full_name: "test full name update",
      gender: :male,
      password: "passwordupdate",
      status: :inactive
    }
  end

  def invalid_user_factory do
    %User{email: ""}
  end

  # Event
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
  # Topic
  def topic_factory do
    %Topic{
      description: "topic test description",
      ended_at: ~N[2010-04-17 14:00:00.000000],
      name: "topic name",
      speaker_names: "topic speaker_names",
      started_at: ~N[2010-04-17 14:00:00.000000],
      status: :active,
      event: build(:event),
      code: Liulo.Utils.Randomizer.randomizer(4, :upcase)
    }
  end

  def update_topic_factory do
    %Topic{
      description: "update topic test description",
      ended_at: ~N[2010-04-17 14:00:00.000000],
      name: "update topic name",
      speaker_names: "update topic speaker_names",
      started_at: ~N[2010-04-17 14:00:00.000000],
      status: :active
    }
  end

  def invalid_topic_factory do
    %Topic{
      name: ""
    }
  end

  # Question
  def question_factory do
    %Question{
      description: "question description",
      is_anonymous: true,
      status: :pending,
      vote_count: 0
    }
  end

  def update_question_factory do
    %Question{
      description: "update question description",
      is_anonymous: true,
      status: :answered,
      vote_count: 1
    }
  end

  def invalid_question_factory do
    %Question{
      description: "",
      is_anonymous: true,
      status: :answered,
      vote_count: 42
    }
  end
end
