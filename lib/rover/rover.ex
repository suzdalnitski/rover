defmodule Rover do
  use GenServer, restart: :permanent

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    grid_size = opts[:grid_size]

    # start in the middle of the grid
    x = y = grid_size |> div(2)

    {:ok,
     %{
       position: {x, y},
       grid_size: grid_size,
       # obstacle chance currently is 15%, this should be moved into config
       obstacles: Rover.Obstacles.make_random({grid_size, grid_size}, 0.15)
     }}
  end

  def move(:noop), do: :noop

  def move(direction) do
    GenServer.cast(__MODULE__, {:move, direction})
  end

  @impl true
  def handle_cast(
        {:move, direction},
        %{position: {x, y}, grid_size: grid_size, obstacles: obstacles} = state
      ) do
    new_position =
      case direction do
        :up -> {x, y - 1}
        :down -> {x, y + 1}
        :left -> {x - 1, y}
        :right -> {x + 1, y}
        _ -> {x, y}
      end

    position =
      cond do
        direction == :error ->
          IO.puts("Rover unable to move, invalid command")
          state.position

        not is_valid_position(new_position, {grid_size, grid_size}) ->
          IO.puts("Rover unable to move, outside of grid")
          state.position

        Rover.Obstacles.is_obstacle(new_position, obstacles) ->
          IO.puts("Rover unable to move, encountered obstacle")
          state.position

        true ->
          IO.puts("Rover moved to #{position_to_string(new_position)}")

          print_map({grid_size, grid_size}, new_position, obstacles)
          new_position
      end

    {:noreply, %{state | position: position}}
  end

  defp is_valid_position({x, y}, {grid_width, grid_height}) do
    x >= 0 && x <= grid_width && y >= 0 && y <= grid_height
  end

  defp position_to_string({x, y}), do: "{#{x}, #{y}}"

  defp print_map({grid_width, grid_height}, {rover_x, rover_y}, obstacles) do
    for y <- 0..grid_height do
      for x <- 0..grid_width do
        cond do
          Rover.Obstacles.is_obstacle({x, y}, obstacles) -> IO.write("x")
          x == rover_x && y == rover_y -> IO.write("@")
          true -> IO.write("_")
        end
      end

      IO.write("\n")
    end
  end
end
