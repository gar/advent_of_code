defmodule AoC2020.Day04 do
  @input "../../assets/day04_input.txt" |> Path.expand(__DIR__)

  alias AoC2020.Passport

  def part1 do
    get_data()
    |> Enum.count(&Passport.present?/1)
  end

  def part2 do
    get_data()
    |> Enum.count(&Passport.valid?/1)
  end

  defp get_data() do
    read_input()
    |> Enum.map(&parse_fields/1)
    |> Enum.map(fn fields -> struct(Passport, fields) end)
  end

  defp read_input() do
    @input
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&read_grouping/1)
  end

  defp read_grouping(grouping) do
    grouping
    |> String.split([" ", "\n"], trim: true)
  end

  defp parse_fields(field_strings) do
    field_strings
    |> Enum.map(fn fs -> String.split(fs, ":") end)
    |> Enum.map(fn [ k, v ] -> { String.to_atom(k), v } end)
    |> Keyword.new
  end
end
