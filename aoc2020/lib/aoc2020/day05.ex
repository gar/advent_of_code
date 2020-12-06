defmodule AoC2020.Day05 do
  @input "../../assets/day05_input.txt" |> Path.expand(__DIR__)

  def test do
    seat_id("FBFBBFFRLR")
  end

  def part1 do
    get_seat_ids()
    |> Enum.max()
  end

  def part2 do
    { min, max } = get_seat_ids() |> Enum.min_max()
    Enum.to_list(min..max) -- get_seat_ids()
  end

  def get_seat_ids() do
    read_boarding_passes()
    |> Enum.map(&seat_id/1)
  end

  defp read_boarding_passes() do
    @input
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def seat_id(boarding_pass) do
    row_id(boarding_pass) * 8 + column_id(boarding_pass)
  end

  defp row_id(boarding_pass) do
    boarding_pass
    |> String.codepoints()
    |> Enum.take(7)
    |> search(0..127)
  end

  defp column_id(boarding_pass) do
    boarding_pass
    |> String.codepoints()
    |> Enum.drop(7)
    |> search(0..7)
  end

  def search([], n..n), do: n
  def search([ c | cs ], low..hi) when c in [ "B", "R" ] do
    diff = ((hi-low) / 2) |> Float.ceil() |> trunc()
    mid = low + diff
    search(cs, mid..hi)
  end
  def search([ c | cs ], low..hi) when c in [ "F", "L" ] do
    diff = ((hi-low) / 2) |> Float.floor() |> trunc()
    mid = low + diff
    search(cs, low..mid)
  end
end
