defmodule LiquidPlanner do
  @moduledoc """
  Bootstrap LiquidPlanner app.
  """

  use Application

  def start(_type, _args) do
      LiquidPlanner.Supervisor.start_link()
  end
end
