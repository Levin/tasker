defmodule Tasker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    task_runner_config = [
      strategy: :one_for_one,
      max_seconds: 30,
      name: Tasker.TaskRunner
    ]
    children = [
      # Starts a worker by calling: Tasker.Worker.start_link(arg)
      # {Tasker.Worker, arg}
      {Registry, keys: :unique, name: Tasker.TaskRegistry},
      {DynamicSupervisor, task_runner_config},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tasker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
