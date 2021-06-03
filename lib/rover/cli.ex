defmodule Rover.Cli do
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, opts}
    }
  end

  def start_link() do
    print_istructions()

    loop()
  end

  defp print_istructions() do
    IO.puts("")
    IO.puts("Alon Nusk Martian Rover")
    IO.puts("================================")
    IO.puts("")
    IO.puts("Please use u(up) d(down) l(left) r(right)")
    IO.puts("Press enter after entering a command")
    IO.puts("")
  end

  defp loop() do
    IO.read(1) |> key_to_command() |> Rover.move()
    IO.puts("")

    loop()
  end

  defp key_to_command(key) do
    case key do
      "u" -> :up
      "d" -> :down
      "l" -> :left
      "r" -> :right
      "\n" -> :noop
      _ -> :error
    end
  end
end
