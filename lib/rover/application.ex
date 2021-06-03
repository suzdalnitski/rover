defmodule Rover.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # ideally the grid_size should go into config
      {Rover, [grid_size: 10]}
    ]

    # don't run the CLI in debug mode
    # used for IEX testing
    children =
      if System.get_env("DEBUG") == "true" do
        children
      else
        children ++ [Rover.Cli]
      end

    opts = [strategy: :one_for_one, name: Rover.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
