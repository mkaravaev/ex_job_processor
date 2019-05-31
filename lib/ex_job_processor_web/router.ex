defmodule ExJobProcessorWeb.Router do
  use ExJobProcessorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExJobProcessorWeb do
    pipe_through :api
    post "/", JobsController, :process
    post "/to_bash", JobsController, :to_bash
  end
end
