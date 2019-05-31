defmodule ExJobProcessing.JobProcessingTest do
  use ExUnit.Case
  alias ExJobProcessor.{Tasks, JobProcessing, ProcessedJobTask}

  setup [:build_tasks]

  test "should process tasks", %{tasks: tasks} do
    result =
      tasks
      |> Tasks.wrap()
      |> JobProcessing.run()

    assert result == expected_result()
  end

  defp build_tasks(_) do
    tasks =
      [
        %{command: "touch hello1.txt", name: "task_1"},
        %{command: "touch hello2.txt", name: "task_2", requires: ["task_3"]},
        %{command: "touch hello3.txt", name: "task_3", requires: ["task_1"]},
        %{command: "touch hello4.txt", name: "task_4", requires: ["task_2", "task_3"]}
      ]

    [tasks: tasks]
  end

  defp expected_result do
    [
      %ProcessedJobTask{command: "touch hello1.txt", name: "task_1"},
      %ProcessedJobTask{command: "touch hello3.txt", name: "task_3"},
      %ProcessedJobTask{command: "touch hello2.txt", name: "task_2"},
      %ProcessedJobTask{command: "touch hello4.txt", name: "task_4"}
    ]
  end
end
