defmodule ExJobProcessor.JobProcessing do
  alias ExJobProcessor.{Tasks, JobTask, ProcessedJobTask}
  alias ExJobProcessor.TaskProcessing

  @type tasks_list :: [JobTask.t] | [String.t]
  @type executed_tasks :: [ProcessedJobTask.t]

  @spec run(tasks_list) :: [executed_tasks]
  def run(tasks_list) do
    tasks_dictionary = tasks_list
    _run(tasks_list, [], tasks_dictionary)
  end

  defp _run([], acc, _dict), do: Enum.reverse(acc)
  defp _run([head|_] = tasks, acc, dict) do
    if Tasks.has_requires?(head) do
      process_with_requires(tasks, acc, dict)
    else
      process_without_requires(tasks, acc, dict)
    end
  end

  defp process_with_requires([head | tail], acc, dict) do
    acc =
      process_requires(head.requires, acc, dict)
      |> process_job(head)

    _run(tail, acc, dict)
  end

  def process_without_requires([head | tail], acc, dict) do
    if already_processed?(head, acc) do
      _run(tail, acc, dict)
    else
      _run(tail, [process(head) | acc], dict)
    end
  end

  defp process_job(acc, head) do
    if already_processed?(head, acc) do
      acc
    else
      [process(head) | acc]
    end
  end

  defp process_requires([], acc, _dict), do: acc
  defp process_requires([head | tail], acc, dict) do
    if already_processed?(head, acc) do
      acc
    else
      processed_task =
        get_task(head, dict)
        |> process()
      process_requires(tail, [processed_task | acc], dict)
    end
  end

  defp process(task), do: TaskProcessing.run(task)

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
