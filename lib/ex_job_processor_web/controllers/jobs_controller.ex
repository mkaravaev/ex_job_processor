defmodule ExJobProcessorWeb.JobsController do
  use ExJobProcessorWeb, :controller

  def process(conn, %{"tasks" => tasks}) do
    with executed_tasks <- ExJobProcessor.process_tasks(tasks),
      do: render(conn, "process.json", tasks: executed_tasks)
  end

  def to_bash(conn, %{"tasks" => tasks}) do
    with executed_tasks <- ExJobProcessor.process_tasks(tasks),
      do: render(conn, "to_bash.txt", tasks: executed_tasks)
  end

end
