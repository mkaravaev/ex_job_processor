defmodule ExJobProcessor.TaskProcessingTest do
  use ExUnit.Case
  alias ExJobProcessor.{TaskProcessing, JobTask}

  @file_name "hello_world.txt"
  @no_file_error 'cat: #{@file_name}: No such file or directory\n'

  describe "&run/1" do
    setup do
      [task: "touch #{@file_name}"]
    end

    setup do
      on_exit fn ->
        clean_file(@file_name)
      end
    end

    test "should execute command", context do
      refute ls_folder_cmd() |> to_string =~ @file_name
      TaskProcessing.run(context.task)
      assert ls_folder_cmd() |> to_string =~ @file_name
    end
  end

  defp cat_file_cmd(file_name) do
    Enum.join(["cat", @file_name], " ")
    |> TaskProcessing.run()
  end

  defp ls_folder_cmd(), do: TaskProcessing.run("ls")

  defp clean_file(file_name) do
    Enum.join(["rm", @file_name], " ")
    |> TaskProcessing.run()
  end
end
