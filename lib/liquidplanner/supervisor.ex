defmodule LiquidPlanner.Supervisor do
    @moduledoc """
    Supervisor tree stuff.
    """

    use Supervisor

    def start_link(opts \\ []) do
        Supervisor.start_link(__MODULE__, :ok, opts)
    end

    def init(:ok) do
      # List all child processes to be supervised
      children = [
        worker(LiquidPlanner.HTTP, [])
      ]
      supervise(children, strategy: :one_for_one)
    end
end
