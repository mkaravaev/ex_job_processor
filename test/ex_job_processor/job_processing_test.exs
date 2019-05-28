defmodule ExJobProcessing.JobProcessingTest do
  use ExUnit.Case
  alias ExJobProcessor.{JobProcessing, TaskProcessing, JobTask}

  @tag :focus
  test "should process tasks" do
    tasks = get_tasks()
    JobProcessing.run(tasks) |> IO.inspect
    assert 1 == 1
  end

  defp get_tasks do
    [
      %JobTask{command: "touch hello1.txt", name: "task_1", requires: ["task_3"]},
      %JobTask{command: "touch hello2.txt", name: "task_2"},
      %JobTask{command: "touch hello3.txt", name: "task_3"}
    ]

  end
  
end
