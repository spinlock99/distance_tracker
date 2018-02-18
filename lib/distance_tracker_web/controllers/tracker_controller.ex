defmodule DistanceTrackerWeb.TrackerController do
  use DistanceTrackerWeb, :controller
  use PhoenixSwagger

  alias DistanceTracker.{Repo, Users}
  alias DistanceTracker.Users.Tracker
  alias DistanceTrackerWeb.ErrorView
  alias Plug.Conn

  action_fallback DistanceTrackerWeb.FallbackController

  def swagger_definitions do
    %{
      Tracker: swagger_schema do
        title "Tracker"
        description "A recording of an activity."
        properties do
          activity :string, "The activity recorded", required: true
          completed_at :string, "When the activity was completed", format: "ISO-8601"
          distance :integer, "How far the activity went", required: true
          inserted_at :string, "When was the activity initially inserted", format: "ISO-8601"
          updated_at :string, "When was the activity last updated", format: "ISO-8601"
          uuid :string, "The ID of the activity"
        end
        example %{
          completed_at: "2017-03-21T14:00:00Z",
          activity: "climbing",
          distance: 150
        }
      end,
      Trackers: swagger_schema do
        title "Trackers"
        description "All recorded activities"
        type :array
        items Schema.ref(:Tracker)
      end,
      Error: swagger_schema do
        title "Error"
        description "Error response from API"
        properties do
          error :string, "The error message", required: true
        end
      end
    }
  end

  swagger_path :index do
      get "/api/trackers"
      summary "List all recorded activities"
      description "List all recorded activities"
      response 200, "Ok", Schema.ref(:Trackers)
  end

  def index(conn, _params) do
    trackers = Users.list_trackers()
    render(conn, "index.json", trackers: trackers)
  end

  def create(conn, %{"tracker" => tracker_params}) do
    with {:ok, %Tracker{} = tracker} <- Users.create_tracker(tracker_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", tracker_path(conn, :show, tracker))
      |> render("show.json", tracker: tracker)
    end
  end

  def show(conn, %{"id" => id}) do
    with tracker = %Tracker{} <- Repo.get(Tracker, id) do
      render(conn, "show.json", tracker: tracker)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end

  def update(conn, %{"id" => id, "tracker" => tracker_params}) do
    tracker = Users.get_tracker!(id)

    with {:ok, %Tracker{} = tracker} <- Users.update_tracker(tracker, tracker_params) do
      render(conn, "show.json", tracker: tracker)
    end
  end

  def delete(conn, %{"id" => uuid}) do
    with tracker = %Tracker{} <- Repo.get(Tracker, uuid) do
      Repo.delete!(tracker)
      conn
      |> Conn.put_status(204)
      |> Conn.send_resp(:no_content, "")
    else
      nil ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", error: "Not found")
    end
  end
end
