defmodule ExJobProcessor.TaskProcessing do
  alias ExJobProcessor.JobTask

  @type task :: JobTask.t()

  @spec run(task) :: {:ok, task}
  def run(task) do
    task.command
    |> execute_command()
  end

  defp execute_command(command) when is_binary(command) do
    command
    |> String.to_charlist()
    |> :os.cmd()
  end
end
