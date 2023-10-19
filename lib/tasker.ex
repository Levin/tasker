defmodule Tasker do

  alias Tasker.{TaskSupervisor, TaskRunner}

  def start_tasks(args) do
    DynamicSupervisor.start_child(TaskRunner, {TaskSupervisor, args})
  end

  def running_imports() do
    match_all = {:"$1", :"$2", :"$3"}
    guards = [{:"==", :"$3", "import"}]
    map_result = [%{id: :"$1", pid: :"$2", type: :"$3"}]
    Registry.select(Tasker.TaskRegistry, [{match_all, guards, map_result}])
  end

end
