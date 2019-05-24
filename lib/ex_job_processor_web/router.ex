defmodule ExJobProcessorWeb.Router do
  use ExJobProcessorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExJobProcessorWeb do
    pipe_through :api
  end
end
