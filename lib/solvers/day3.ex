defmodule Aoc2023.Solvers.Day3 do
  @behaviour Aoc2023.Solver

  alias Aoc2023.Solvers.Day3.Number
  alias Aoc2023.Solvers.Day3.Position

  @symbols ["#", "*", "+", "$", "/", "&", "=", "-", "@", "%"]

  @type symbol :: String.grapheme()
  @type symbols :: %{Position.t() => String.grapheme()}

  @impl Aoc2023.Solver
  def solve_part_1(input) do
    numbers = parse_numbers(input)
    symbols = parse_symbols(input)

    numbers
    |> Enum.filter(&has_neighboring_symbol?(&1, symbols))
    |> Enum.map(fn number -> number.value end)
    |> Enum.sum()
  end

  @impl Aoc2023.Solver
  def solve_part_2(input) do
    numbers = parse_numbers(input)
    symbols = parse_symbols(input)

    for number <- numbers,
        neighboring_gear <- find_neighboring_gears(number, symbols) do
      {number, neighboring_gear}
    end
    |> Enum.reduce(%{}, fn {number, gear_position}, acc ->
      Map.update(acc, gear_position, [number], fn neighbors -> [number | neighbors] end)
    end)
    |> Enum.map(fn
      {_, [number1, number2]} -> number1.value * number2.value
      _ -> 0
    end)
    |> Enum.sum()
  end

  @spec find_neighboring_gears(Number.t(), symbols()) :: list(Position.t())
  def find_neighboring_gears(number, symbols) do
    for row <- (number.position.row - 1)..(number.position.row + 1),
        column <- (number.position.column - 1)..(number.position.column + number.length),
        position = Position.new(row, column),
        symbols[position] == "*" do
      position
    end
  end

  @spec has_neighboring_symbol?(Number.t(), symbols()) :: boolean()
  def has_neighboring_symbol?(number, symbols) do
    neighbor_positions =
      for row <- (number.position.row - 1)..(number.position.row + 1),
          column <- (number.position.column - 1)..(number.position.column + number.length) do
        Position.new(row, column)
      end

    Enum.any?(neighbor_positions, fn position -> Map.has_key?(symbols, position) end)
  end

  @spec parse_symbols(String.t()) :: symbols()
  def parse_symbols(input) do
    for {line, row} <- input |> String.split("\n") |> Enum.with_index(),
        {grapheme, column} <- line |> String.graphemes() |> Enum.with_index(),
        grapheme in @symbols,
        into: %{} do
      {Position.new(row, column), grapheme}
    end
  end

  @spec parse_numbers(String.t()) :: list(Number.t())
  defp parse_numbers(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, row} -> parse_line_for_numbers(line, row) end)
  end

  @spec parse_line_for_numbers(String.t(), non_neg_integer()) :: list(Number.t())
  defp parse_line_for_numbers(line, row) do
    parse_line_for_numbers(String.graphemes(line), row, 0, [])
  end

  @spec parse_line_for_numbers(
          list(String.grapheme()),
          non_neg_integer(),
          non_neg_integer(),
          list(Number.t())
        ) ::
          list(Number.t())
  defp parse_line_for_numbers([], _row, _column, numbers), do: numbers

  defp parse_line_for_numbers([grapheme | rest], row, column, numbers)
       when grapheme in @symbols or grapheme == "." do
    parse_line_for_numbers(rest, row, column + 1, numbers)
  end

  defp parse_line_for_numbers(graphemes, row, column, numbers) do
    {number, graphemes_rest} = parse_number(graphemes, Position.new(row, column))
    parse_line_for_numbers(graphemes_rest, row, column + number.length, [number | numbers])
  end

  @spec parse_number(list(String.grapheme()), Position.t()) ::
          {Number.t(), list(String.grapheme())}
  defp parse_number(graphemes, position) do
    {number_graphemes, rest_graphemes} =
      Enum.split_while(graphemes, &match?({_, _}, Integer.parse(&1)))

    number_value =
      number_graphemes
      |> Enum.join()
      |> String.to_integer()

    number = Number.new(number_value, positive_length(number_graphemes), position)

    {number, rest_graphemes}
  end

  @spec positive_length(list()) :: pos_integer()
  defp positive_length(list) do
    case length(list) do
      0 -> raise("Expected a non-empty list")
      l -> l
    end
  end

  defmodule Number do
    alias Aoc2023.Solvers.Day3.Position

    @enforce_keys [:value, :length, :position]
    defstruct [:value, :length, :position]

    @type t :: %__MODULE__{
            value: integer(),
            length: pos_integer(),
            position: Position.t()
          }

    @spec new(integer(), pos_integer(), Position.t()) :: t()
    def new(value, length, position),
      do: %__MODULE__{
        value: value,
        length: length,
        position: position
      }
  end

  defmodule Symbol do
    @enforce_keys [:value]
    defstruct [:value]

    @type t :: %__MODULE__{
            value: String.t()
          }

    @spec new(String.t()) :: t()
    def new(value), do: %__MODULE__{value: value}
  end

  defmodule Position do
    @enforce_keys [:row, :column]
    defstruct [:row, :column]

    @type t :: %__MODULE__{
            row: non_neg_integer(),
            column: non_neg_integer()
          }

    @spec new(non_neg_integer(), non_neg_integer()) :: t()
    def new(row, column), do: %__MODULE__{row: row, column: column}
  end
end
