defmodule DistanceTrackerWeb.TrackerView do
  use DistanceTrackerWeb, :view
  alias DistanceTrackerWeb.TrackerView

  def render("index.json", %{trackers: trackers}) do
    %{data: render_many(trackers, TrackerView, "tracker.json")}
  end

  def render("show.json", %{tracker: tracker}) do
    %{data: render_one(tracker, TrackerView, "tracker.json")}
  end

  def render("tracker.json", %{tracker: tracker}) do
    %{
      uuid: tracker.uuid,
      activity: tracker.activity,
      completed_at: tracker.completed_at,
      distance: tracker.distance,
      inserted_at: tracker.inserted_at,
      updated_at: tracker.updated_at
    }
  end
end
