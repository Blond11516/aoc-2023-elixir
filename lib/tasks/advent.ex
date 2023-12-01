defmodule Mix.Tasks.Advent do
  @moduledoc """
  Mix task for running the solution for a given AdventOfCode challenge.

  The task can be called as follows:
  `mix advent day [part] [--test data]`
  * day: The day for which to run the solution
  * part: The part of the day for which to run the solution. Defaults to 1.
  * --test data: Used for passing test data to the solver. If not present, the corresponding input file is used instead.
  * --profile: Runs the given day and part with the ExProf profiler.
  """

  use Mix.Task

  alias Aoc2023.Input

  import ExProf.Macro

  @spec run([any]) :: :ok
  def run(argv) do
    {switches, args, _} = OptionParser.parse(argv, strict: [test: :string, profile: :boolean])

    run_task(args, switches)
  end

  defp run_task([], _switches) do
    IO.puts("Missing required argument <day>")
  end

  defp run_task([_day, part], _switches) when part not in ["1", "2"] do
    IO.puts("Invalid part value: #{part}")
  end

  defp run_task([day], switches) do
    run_task([day, "1"], switches)
  end

  defp run_task([day, part], switches) do
    day = String.to_integer(day)
    part = String.to_integer(part)

    data = get_input(day, switches)

    if Keyword.has_key?(switches, :profile) do
      profile do
        run_day_part(day, part, data)
      end
    else
      run_day_part(day, part, data)
    end
  end

  defp run_day_part(day, part, input) do
    IO.puts("\nExecuting day #{day}, part #{part}")
    output = solve(day, part, input)
    IO.puts("Output: #{output}")
  end

  defp solve(day, part, input) do
    {time, result} = :timer.tc(fn -> Aoc2023.Solver.solve(day, part, input) end, :microsecond)

    IO.puts("\nExecution time: #{time}µs")

    result
  end

  defp get_input(day, switches) do
    if Keyword.has_key?(switches, :test) do
      test_data = Keyword.fetch!(switches, :test)
      String.replace(test_data, "\\n", "\n")
    else
      Input.get_raw(day)
    end
  end
end
