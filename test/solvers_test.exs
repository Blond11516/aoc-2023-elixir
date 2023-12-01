defmodule Aoc2023.SolversTest do
  use ExUnit.Case

  alias Aoc2023.Answer
  alias Aoc2023.Input
  alias Aoc2023.Solver

  for file <- File.ls!("answers"),
      day = file |> Path.rootname() |> String.to_integer(),
      part <- [1, 2] do
    test "day #{day}, part #{part}" do
      test_day_part(unquote(day), unquote(part))
    end
  end

  defp test_day_part(day, part) do
    answer = Solver.solve(day, part, Input.get_raw(day))

    expectation = Answer.get_answer(day, part)
    assert answer == expectation
  end
end
