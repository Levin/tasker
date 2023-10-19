defmodule Tasker.Task do
  use GenServer, restart: :transient
  require Logger

  #def start(opts) do
  #  GenServer.start_link(Task, opts)
  #end

  defstruct [:id, :tasks] 


  def start_link(args) do
    args = 
      if Keyword.has_key?(args, :id) do
        args
      else 
        Keyword.put(args, :id, random_job())
      end

    id = Keyword.get(args, :id)
    type = Keyword.get(args, :type)

    GenServer.start_link(__MODULE__, args, name: via(id, type))
  end

  @impl true
  def init(args) do
    task = Keyword.fetch!(args, :task)
    id = Keyword.get(args, :id)

    state = %Tasker.Task{tasks: task, id: id}
    {:ok, state, {:continue, :run}}
  end

  @impl true
  def handle_cast({:new_task, task}, state) do
{:noreply, %{state | tasks: [task | state.tasks]}}
  end

  @impl true
  def handle_call(:tasks, _from,  state) do
    IO.puts("[#{__MODULE__}] holds #{inspect state.tasks} ")
    {:noreply, state}
  end

  def handle_cast({:finish, taskname}, state) do
    changed_tasks = Enum.reject(state.tasks, &(&1.task == taskname))
    {:noreply, %{state | tasks: changed_tasks}}
  end

  defp via(key, value) do
    {:via, Registry, {Tasker.TaskRegistry, key, value}}
  end


  defp random_job() do
    []
  end

end
