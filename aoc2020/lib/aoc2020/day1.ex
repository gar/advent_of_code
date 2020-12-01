defmodule AOC2020.Day1 do
  def part1 do
    "../../assets/day1_input.txt"
    |> load_input()
    |> permutations2()
    |> Enum.find(fn { x, y } -> x + y == 2020 end)
    |> (fn { x, y } -> x * y end).()
  end

  def part2 do
    "../../assets/day1_input.txt"
    |> load_input()
    |> permutations3()
    |> Enum.find(fn { x, y, z } -> x + y + z == 2020 end)
    |> (fn { x, y, z } -> x * y * z end).()
  end

  defp load_input(relative_filepath) do
    relative_filepath
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split
    |> Enum.map(&String.to_integer/1)
  end

  defp permutations2(integers) do
    for x <- integers, y <- integers, x != y, do: { x, y }
  end

  defp permutations3(integers) do
    for x <- integers, y <- integers, z <- integers, x != y, x != z, do: { x, y, z }
  end
end
