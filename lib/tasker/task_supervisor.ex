defmodule Tasker.TaskSupervisor do
  @moduledoc """
    This Supervisor handles the other ones. The structure is loike the following : 
              Task.TaskSupervisor - cannot crash because of restart: :temporary => overlooks crashing Processes
                    |
                    |
          Tasker    Tasker    Tasker - can crash, restarts itself if Task crashed too often
          - Task    - Task    - Task
    """
  use Supervisor, restart: :temporary

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init(args) do
    children = 
      [
        {Tasker.Task, args}
      ]
    options = 
      [
        strategy: :one_for_one,
        max_seconds: 30
      ]
    Supervisor.init(children, options)

  end



end
