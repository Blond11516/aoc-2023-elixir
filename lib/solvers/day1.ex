defmodule Aoc2023.Solvers.Day1 do
  @behaviour Aoc2023.Solver

  @impl Aoc2023.Solver
  def solve_part_1(input) do
    input
    |> String.split()
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> keep_numbers()
      |> then(fn numbers -> {hd(numbers), List.last(numbers)} end)
      |> then(fn {first, last} -> "#{first}#{last}" end)
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  @impl Aoc2023.Solver
  def solve_part_2(input) do
    input
    |> String.split()
    |> Enum.map(fn line ->
      line
      |> keep_numbers_with_spelled_out()
      |> then(fn numbers -> {hd(numbers), List.last(numbers)} end)
      |> then(fn {first, last} -> "#{first}#{last}" end)
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  defp keep_numbers(graphemes) do
    Enum.filter(graphemes, fn grapheme -> match?({_, _}, Integer.parse(grapheme)) end)
  end

  defp keep_numbers_with_spelled_out(line) do
    keep_numbers_with_spelled_out(line, [])
  end

  defp keep_numbers_with_spelled_out("", digits), do: Enum.reverse(digits)

  defp keep_numbers_with_spelled_out(line, digits) do
    digits =
      case line do
        "1" <> _ -> ["1" | digits]
        "2" <> _ -> ["2" | digits]
        "3" <> _ -> ["3" | digits]
        "4" <> _ -> ["4" | digits]
        "5" <> _ -> ["5" | digits]
        "6" <> _ -> ["6" | digits]
        "7" <> _ -> ["7" | digits]
        "8" <> _ -> ["8" | digits]
        "9" <> _ -> ["9" | digits]
        "one" <> _ -> ["1" | digits]
        "two" <> _ -> ["2" | digits]
        "three" <> _ -> ["3" | digits]
        "four" <> _ -> ["4" | digits]
        "five" <> _ -> ["5" | digits]
        "six" <> _ -> ["6" | digits]
        "seven" <> _ -> ["7" | digits]
        "eight" <> _ -> ["8" | digits]
        "nine" <> _ -> ["9" | digits]
        _ -> digits
      end

    keep_numbers_with_spelled_out(String.slice(line, 1..-1), digits)
  end
end
