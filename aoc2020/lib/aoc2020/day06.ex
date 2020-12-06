defmodule AoC2020.Day06 do
  @input "../../assets/day06_input.txt" |> Path.expand(__DIR__)

  def part1 do
    read_input()
    |> Enum.map(&unique_yesses/1)
    |> Enum.map(&MapSet.size/1)
    |> Enum.reduce(&+/2)
  end

  def part2 do
    read_input()
    |> Enum.map(&common_yesses/1)
    |> Enum.map(&MapSet.size/1)
    |> Enum.reduce(&+/2)
  end

  def read_input() do
    @input
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(&read_group/1)
  end

  def read_group(group) do
    group
    |> Enum.map(&read_row/1)
  end

  def read_row(row) do
    row
    |> String.codepoints()
    |> MapSet.new()
  end

  def unique_yesses(group) do
    group
    |> Enum.reduce(&MapSet.union/2)
  end

  def common_yesses(group) do
    group
    |> Enum.reduce(&MapSet.intersection/2)
  end
end
