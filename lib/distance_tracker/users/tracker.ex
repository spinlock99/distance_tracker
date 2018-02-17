defmodule DistanceTracker.Users.Tracker do
  use Ecto.Schema
  import Ecto.Changeset
  alias DistanceTracker.Users.Tracker


  schema "trackers" do

    timestamps()
  end

  @doc false
  def changeset(%Tracker{} = tracker, attrs) do
    tracker
    |> cast(attrs, [])
    |> validate_required([])
  end
end
