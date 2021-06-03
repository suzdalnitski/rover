defmodule Rover.Obstacles do
  def make_random({grid_width, grid_height}, chance \\ 0.1) do
    for x <- 0..grid_width, y <- 0..grid_height, into: %{} do
      {{x, y}, :rand.uniform() <= chance}
    end
  end

  def is_obstacle({x, y}, %{} = obstacles) do
    obstacles[{x, y}] == true
  end
end
