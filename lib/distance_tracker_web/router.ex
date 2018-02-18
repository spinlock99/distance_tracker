defmodule DistanceTrackerWeb.Router do
  use DistanceTrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DistanceTrackerWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/trackers", TrackerController, except: [:new, :edit]
  end

  def swagger_info do
    %{
      info: %{
        version: "0.0.2",
        title: "Distance Tracker",
        host: "shere-out-app.is.hosted",
      }
    }
  end
end
