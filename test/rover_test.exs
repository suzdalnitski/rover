defmodule RoverTest do
  use ExUnit.Case
  doctest Rover

  test "greets the world" do
    assert Rover.hello() == :world
  end
end
