defmodule Aoc2023.Input do
  def get_raw(day) do
    "inputs/#{day}.txt"
    |> File.read!()
    |> String.trim()
  end
end
