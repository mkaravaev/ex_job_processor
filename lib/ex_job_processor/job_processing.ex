defmodule ExJobProcessor.JobProcessing do
  alias ExJobProcessor.JobTask
  alias ExJobProcessor.TaskProcessing

  @type task :: JobTask.t
  @type list_of_tasks :: [task]

  @spec run(list_of_tasks) :: list_of_tasks
  def run(tasks), do: run(tasks, [])
  def run([], result_acc) do
    result_acc
    |> List.flatten
    |> Enum.reverse()
  end
  def run([%JobTask{requires: requires} = head | tail] = tasks, acc) do
    case requires do
      nil -> process_task(tail, head, acc)

      list when is_list(list) ->
        result = process_requires(list, tasks)
        acc = result ++ acc
        root_task = process(head)
        run(tail, [root_task | acc])
    end
  end

  defp process_task(left_tasks, task, []) do
    run(left_tasks, [process(task)])
  end
  defp process_task(left_tasks, task, acc) do
    get_task(task.name, acc)
    |> case do
         nil -> run(left_tasks, [process(task) | acc])
         %JobTask{} -> run(left_tasks, acc)
       end
  end

  defp process_requires(task_names, tasks) do
    tasks = get_tasks(task_names, tasks)
    run(tasks)
  end

  defp get_tasks(task_names, tasks) do
    for name <- task_names do
      get_task(name, tasks)
    end
  end

  defp process(task), do: TaskProcessing.run(task)

  defp get_task(name, tasks) do
    Enum.find(tasks, &(&1.name == name))
  end

end
