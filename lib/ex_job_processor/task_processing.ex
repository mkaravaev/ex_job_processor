defmodule ExJobProcessor.TaskProcessing do
  alias ExJobProcessor.JobTask

  @type task :: JobTask.t

  @spec run(task) :: String.t
  @spec run(String.t) :: String.t
  def run(%JobTask{command: cmd}), do: execute_command(cmd)
  def run(cmd) when is_binary(cmd), do: execute_command(cmd)

  defp execute_command(command) when is_binary(command) do
    command
    |> String.to_charlist()
    |> :os.cmd()
    |> IO.inspect(label: "#{command}")
  end
end
