defmodule ExJobProcessor.Tasks do
  alias ExJobProcessor.{JobTask, ProcessedJobTask}

  def wrap(tasks) when is_list(tasks) do
    for task <- tasks do
      _wrap(task)
    end
  end

  def wrap_processed(task) do
    task_map = Map.from_struct(task)
    struct(ProcessedJobTask, task_map)
  end

  def has_requires?(%JobTask{requires: nil}), do: false
  def has_requires?(%JobTask{requires: requires}) when is_list(requires), do: true

  defp _wrap(task) do
    %JobTask{
      name: task["name"] || task.name,
      command: task["command"] || task.command,
      requires: task["requires"] || Map.get(task, :requires, nil)
    }
  end

end
