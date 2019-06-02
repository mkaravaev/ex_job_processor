defmodule ExJobProcessor.JobProcessing do
  alias ExJobProcessor.{Tasks, JobTask, ProcessedJobTask}
  alias ExJobProcessor.TaskProcessing

  @type tasks_list :: [JobTask.t] | [String.t]
  @type executed_tasks :: [ProcessedJobTask.t]
  @type opts :: [no_execution: true] | [] | nil

  @spec run(tasks_list, opts) :: [executed_tasks]
  def run(tasks_list, opts\\[]) do
    tasks_dictionary = tasks_list
    _run(tasks_list, [], tasks_dictionary, opts)
  end

  defp _run([], acc, _dict, _opts), do: Enum.reverse(acc)
  defp _run([head|_] = tasks, acc, dict, opts) do
    if Tasks.has_requires?(head) do
      process_with_requires(tasks, acc, dict, opts)
    else
      process_without_requires(tasks, acc, dict, opts)
    end
  end

  defp process_with_requires([head | tail], acc, dict, opts) do
    acc =
      process_requires(head.requires, acc, dict, opts)
      |> process_job(head, opts)

    _run(tail, acc, dict, opts)
  end

  defp process_without_requires([head | tail], acc, dict, opts) do
    if already_processed?(head, acc) do
      _run(tail, acc, dict, opts)
    else
      _run(tail, [process(head, opts) | acc], dict, opts)
    end
  end

  defp process_job(acc, head, opts) do
    if already_processed?(head, acc) do
      acc
    else
      [process(head, opts) | acc]
    end
  end

  defp process_requires([], acc, _dict, _opts), do: acc
  defp process_requires([head | tail], acc, dict, opts) do
    if already_processed?(head, acc) do
      acc
    else
      processed_task =
        get_task(head, dict)
        |> process(opts)
      process_requires(tail, [processed_task | acc], dict, opts)
    end
  end

  defp process(task, opts), do: TaskProcessing.run(task, opts)

  defp already_processed?(%JobTask{name: name}, acc), do: _already_processed?(name, acc)
  defp already_processed?(name, acc) when is_binary(name), do: _already_processed?(name, acc)
  defp _already_processed?(name, acc) do
    get_task(name, acc)
    |> case do
         nil -> false
         %ProcessedJobTask{} -> true
       end
  end

  defp get_task(name, tasks) do
    Enum.find(tasks, &(&1.name == name))
  end

end
