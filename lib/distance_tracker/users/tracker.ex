defmodule DistanceTracker.Users.Tracker do
  use Ecto.Schema
  import Ecto.Changeset
  alias DistanceTracker.Users.Tracker

  @derive {Phoenix.Param, key: :uuid}

  @timestamps_opts [type: :utc_datetime, usec: true]
  @primary_key {:uuid, :binary_id, [autogenerate: true]}

  schema "trackers" do
    field :distance, :integer
    field :activity, :string
    field :completed_at, :utc_datetime
    timestamps()
  end

  @doc """
  Builds a changeset based on the `tracker` and `attrs`.
  """
  def changeset(%Tracker{} = tracker, attrs) do
    tracker
    |> cast(attrs, [:completed_at, :activity, :uuid, :distance])
    |> validate_required([:completed_at, :activity])
  end
end
