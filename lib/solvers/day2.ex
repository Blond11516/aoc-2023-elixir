defmodule Aoc2023.Solvers.Day2 do
  @behaviour Aoc2023.Solver

  alias Aoc2023.Solvers.Day2.Configuration
  alias Aoc2023.Solvers.Day2.RecordDraw
  alias Aoc2023.Solvers.Day2.Record

  @impl Aoc2023.Solver
  def solve_part_1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_game_record/1)
    |> Enum.map(&Record.calculate_max_configuration/1)
    |> Enum.filter(fn {_game_id, game_max_config} ->
      Configuration.subset?(game_max_config, Configuration.new(12, 13, 14))
    end)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum()
  end

  @impl Aoc2023.Solver
  def solve_part_2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_game_record/1)
    |> Enum.map(&Record.calculate_max_configuration/1)
    |> Enum.map(fn {_, game_max_configuration} -> game_max_configuration end)
    |> Enum.map(&Configuration.pow/1)
    |> Enum.sum()
  end

  defp parse_game_record(raw_record) do
    "Game " <> raw_record = raw_record
    [raw_id, raw_record] = String.split(raw_record, ":", trim: true)
    id = String.to_integer(raw_id)

    draws =
      raw_record
      |> String.split(";", trim: true)
      |> Enum.map(&parse_draw/1)

    Record.new(id, draws)
  end

  defp parse_draw(raw_draw) do
    drawn_colors =
      raw_draw
      |> String.split(",", trim: true)
      |> Map.new(&parse_drawn_color/1)

    RecordDraw.new(
      Map.get(drawn_colors, :red, 0),
      Map.get(drawn_colors, :green, 0),
      Map.get(drawn_colors, :blue, 0)
    )
  end

  defp parse_drawn_color(raw_drawn_color) do
    [raw_number, raw_color] = String.split(raw_drawn_color, " ", trim: true)

    {String.to_existing_atom(raw_color), String.to_integer(raw_number)}
  end

  defmodule Configuration do
    @enforce_keys [:red, :green, :blue]
    defstruct [:red, :green, :blue]

    def new(red, green, blue), do: %__MODULE__{red: red, green: green, blue: blue}

    def subset?(%__MODULE__{} = config, %__MODULE__{} = possibly_superset_config) do
      config.red <= possibly_superset_config.red and
        config.green <= possibly_superset_config.green and
        config.blue <= possibly_superset_config.blue
    end

    def pow(%__MODULE__{} = config), do: config.red * config.green * config.blue
  end

  defmodule RecordDraw do
    @enforce_keys [:red, :green, :blue]
    defstruct [:red, :green, :blue]

    def new(red, green, blue), do: %__MODULE__{red: red, green: green, blue: blue}
  end

  defmodule Record do
    @enforce_keys [:game_id, :draws]
    defstruct [:game_id, :draws]

    def new(game_id, draws), do: %__MODULE__{game_id: game_id, draws: draws}

    def calculate_max_configuration(%__MODULE__{} = record) do
      max_config =
        Enum.reduce(record.draws, Configuration.new(0, 0, 0), fn draw, configuration ->
          Configuration.new(
            max(configuration.red, draw.red),
            max(configuration.green, draw.green),
            max(configuration.blue, draw.blue)
          )
        end)

      {record.game_id, max_config}
    end
  end
end
