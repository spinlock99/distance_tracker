defmodule DistanceTracker.Repo.Migrations.CreateTrackers do
  use Ecto.Migration

  def change do
    create table(:trackers) do
      add :uuid, :uuid, primary_key: true
      add :distance, :integer
      add :activity, :string
      add :completed_at, :utc_datetime
      timestamps()
    end

  end
end
