defmodule ExJobProcessorWeb.JobsControllerTest do
  use ExJobProcessorWeb.ConnCase

  setup [:build_tasks]

  describe "/" do
    @tag :focus1
    test "should process job", %{conn: conn, tasks: tasks} do
      conn = post(conn, jobs_path(conn, :process), tasks: tasks)
      assert json_response(conn, 200) == [%{"command" => "touch hello3.txt", "name" => "task_3"}, %{"command" => "touch hello1.txt", "name" => "task_1"}, %{"command" => "touch hello2.txt", "name" => "task_2"}]
    end
  end

  describe "/to_bash" do
    @tag :focus
    test "should render bash script text", %{conn: conn, tasks: tasks} do
      conn = post(conn, jobs_path(conn, :to_bash), tasks: tasks)
      assert text_response(conn, 200) == "#!/usr/bin/env bash\ntouch hello3.txt\ntouch hello1.txt\ntouch hello2.txt\n\n"
    end
  end

  #NOTICE duplication at /job_processing_test.exs
  defp build_tasks(_) do
    tasks =
      [
        %{command: "touch hello1.txt", name: "task_1", requires: ["task_3"]},
        %{command: "touch hello2.txt", name: "task_2"},
        %{command: "touch hello3.txt", name: "task_3"}
      ]

    [tasks: tasks]
  end

  
end
