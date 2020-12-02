defmodule AoC2020.Day02 do
  @input "../../assets/day02_input.txt" |> Path.expand(__DIR__)

  def part1 do
    read_input()
    |> Enum.map(&extract_pattern/1)
    |> Enum.map(&valid_min_max?/1)
    |> Enum.count(&(&1))
  end

  def part2 do
    read_input()
    |> Enum.map(&extract_pattern/1)
    |> Enum.map(&valid_presence?/1)
    |> Enum.count(&(&1))
  end

  defp read_input() do
    @input
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  defp extract_pattern(string) do
    Regex.run(~r{(\d+)-(\d+) (.): (.+)}, string, capture: :all_but_first)
    |> List.to_tuple()
    |> (fn { min, max, c, p } -> { String.to_integer(min), String.to_integer(max), c, p } end).()
  end

  defp valid_min_max?({ min, max, char, passwd }) do
    passwd
    |> String.codepoints()
    |> Enum.count(fn c -> c == char end)
    |> between?(min, max)
  end

  defp between?(n, min, max) do
    n >= min and n <= max
  end

  defp valid_presence?({ p1, p2, char, passwd }) do
    c1 = String.at(passwd, p1 - 1)
    c2 = String.at(passwd, p2 - 1)
    (c1 == char or c2 == char) and (c1 != c2)
  end
end
