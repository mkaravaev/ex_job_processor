defmodule ExJobProcessor.JobProcessing do
  alias ExJobProcessor.{JobTask, ProcessedJobTask}
  alias ExJobProcessor.TaskProcessing

  @type task :: JobTask.t
  @type tasks_list :: [task] | [String.t]

  def run(tasks_list) do
    dict = tasks_list
    _run(tasks_list, [], dict)
  end

  defp _run([], acc, _dict), do: acc |> Enum.reverse()

  defp _run([head|tail], acc, dict) do
    if has_requires?(head) do
      acc = process_requires(head.requires, acc, dict)
      acc = 
        if already_processed?(head, acc) do
          acc
        else
          [process(head) | acc]
        end
      _run(tail, acc, dict)
    else
      process_job(head, tail, acc, dict)
    end
  end

  defp process_job(head, tail, acc, dict) do
    if already_processed?(head, acc) do
      _run(tail, acc, dict)
    else
      _run(tail, [process(head) | acc], dict)
    end
  end

  defp process_requires([], acc, _dict), do: acc
  defp process_requires([head | tail], acc, dict) do
    case already_processed?(head, acc) do
      true -> acc
      false ->
        processed_task =
          get_task(head, dict)
          |> process()
        process_requires(tail, [processed_task | acc], dict)
    end
  end

  defp process(task), do: TaskProcessing.run(task)

  def already_processed?(%JobTask{name: name}, acc), do: _already_processed?(name, acc)
  def already_processed?(name, acc), do: _already_processed?(name, acc)
  def _already_processed?(name, acc) do
    get_task(name, acc)
    |> case do
         nil -> false
         %ProcessedJobTask{} -> true
       end
  end

  def has_requires?(%{requires: nil}), do: false
  def has_requires?(%{requires: requires}) when is_list(requires), do: true

  defp get_task(name, tasks) do
    Enum.find(tasks, &(&1.name == name))
  end

end
