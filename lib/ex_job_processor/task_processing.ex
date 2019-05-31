defmodule ExJobProcessor.TaskProcessing do
  alias ExJobProcessor.{JobTask, Tasks}

  @type task :: JobTask.t

  @spec run(String.t) :: String.t
  @spec run(task) :: String.t
  def run(cmd) when is_binary(cmd), do: execute_command(cmd)
  def run(%JobTask{command: cmd} = task) do
    execute_command(cmd)
    Tasks.wrap_processed(task)
  end

  def run(%JobTask{} = task, no_execution: true), do: 
    Tasks.wrap_processed(task)

  defp execute_command(command) when is_binary(command) do
    command
    |> String.to_charlist()
    |> :os.cmd()
  end

end
