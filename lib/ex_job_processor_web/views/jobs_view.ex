defmodule ExJobProcessorWeb.JobsView do
  use ExJobProcessorWeb, :view

  def render("process.json", %{tasks: tasks}) do
    render_many(tasks, __MODULE__, "executed.json", as: :task)
  end

  def render("executed.json", %{task: task}) do
    task
    |> Map.from_struct
    |> Map.drop([:requires])
  end

  def render("to_bash.txt", %{tasks: tasks}) do
    ~s"""
    #!/usr/bin/env bash
    #{render_many(tasks, __MODULE__, "executed_bash.txt", as: :task)}
    """
  end

  def render("executed_bash.txt", %{task: task}) do
    task.command <> "\n"
  end
end
