defmodule ExJobProcessor.TaskProcessing do
  alias ExJobProcessor.JobTask

  @type task :: JobTask.t()
  # @type error :: 

  @spec run(task) :: {:ok, task}
  def run(task) do
    task.command
    |> execute_command()
  end

  defp execute_command(command) when is_binary(command) do
    :os.cmd(command)
  end
end
