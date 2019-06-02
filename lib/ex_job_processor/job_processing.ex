defmodule ExJobProcessor.JobProcessing do
  alias ExJobProcessor.{Tasks, JobTask, ProcessedJobTask}
  alias ExJobProcessor.TaskProcessing

  @type tasks_list :: [JobTask.t] | [String.t]
  @type executed_tasks :: [ProcessedJobTask.t]
  @type opts :: keyword()

  @spec run(tasks_list, opts) :: [executed_tasks]
  def run(tasks_list, opts\\[]) do
    opts = Keyword.merge(opts, [dict: tasks_list])
    run(tasks_list, [], opts)
  end

  defp run([], acc, _opts), do: Enum.reverse(acc)
  defp run([head|_] = tasks, acc, opts) do
    if Tasks.has_requires?(head) do
      process_with_requires(tasks, acc, opts)
    else
      process_without_requires(tasks, acc, opts)
    end
  end

  defp process_with_requires([head | tail], acc, opts) do
    acc =
      process_requires(head.requires, acc, opts)
      |> process_parent_task(head, opts)

    run(tail, acc, opts)
  end

  defp process_without_requires([head | tail], acc, opts) do
    if already_processed?(head, acc) do
      run(tail, acc, opts)
    else
      run(tail, [process(head, opts) | acc], opts)
    end
  end

  defp process_parent_task(acc, head, opts) do
    if already_processed?(head, acc) do
      acc
    else
      [process(head, opts) | acc]
    end
  end

  defp process_requires([], acc, _opts), do: acc
  defp process_requires([head | tail], acc, opts) do
    if already_processed?(head, acc) do
      acc
    else
      processed_task =
        get_task(head, opts[:dict])
        |> process(opts)

      process_requires(tail, [processed_task | acc], opts)
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
