defmodule Aoc2023.Solver do
  @moduledoc "Behaviour for solvers"

  @callback solve_part_1(input :: String.t()) :: integer()
  @callback solve_part_2(input :: String.t()) :: integer()

  @doc "Execute the solver for a day and part with an input"
  @spec solve(pos_integer, 1 | 2, String.t()) :: integer()
  def solve(day, part, input) do
    day_module = :"Elixir.Aoc2023.Solvers.Day#{day}"

    case part do
      1 -> day_module.solve_part_1(input)
      2 -> day_module.solve_part_2(input)
    end
  end
end
