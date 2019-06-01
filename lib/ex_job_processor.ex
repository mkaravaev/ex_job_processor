defmodule ExJobProcessor do
  alias ExJobProcessor.{JobProcessing, Tasks, ProcessedJobTask}

  @type params :: map()
  @type executed_tasks :: [ProcessedJobTask.t]

  @spec process_tasks(params) :: [executed_tasks]
  def process_tasks(params) do
    Tasks.wrap(params)
    |> JobProcessing.run()
  end
end
