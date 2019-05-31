defmodule ExJobProcessor do
  alias ExJobProcessor.{JobProcessing, Tasks}
  # TODO add types
  # @type params
  # @type executed_task
  # @type err_msg

  # @spec process_task(params) :: {:ok, [executed_task]} | {:error, err_msg}
  def process_tasks(params) do
    Tasks.wrap(params)
    |> JobProcessing.run()
  end
end
