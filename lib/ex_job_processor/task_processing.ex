defmodule ExJobProcessor.TaskProcessing do
  alias ExJobProcessor.{JobTask, ProcessedJobTask, Tasks}

  @type task :: JobTask.t
  @type processed_task :: ProcessedJobTask.t

  @spec run(String.t) :: processed_task
  @spec run(task) :: processed_task
  def run(cmd) when is_binary(cmd), do: execute_command(cmd)
  def run(%JobTask{} = task, no_execution: true) do
    Tasks.wrap_processed(task)
  end
  def run(%JobTask{command: cmd} = task, _opts) do
    execute_command(cmd)
    Tasks.wrap_processed(task)
  end

  defp execute_command(command) when is_binary(command) do
    command
    |> String.to_charlist()
    |> :os.cmd()
  end

end
