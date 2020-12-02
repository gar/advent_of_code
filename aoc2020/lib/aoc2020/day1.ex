defmodule AoC2020.Day01 do
  @input "../../assets/day01_input.txt" |> Path.expand(__DIR__)

  def part1 do
    read_input()
    |> permutations(2)
    |> find(2020)
    |> product()
  end

  def part2 do
    read_input()
    |> permutations(3)
    |> find(2020)
    |> product()
  end

  defp read_input() do
    @input
    |> File.read!
    |> String.split
    |> Enum.map(&String.to_integer/1)
  end

  defp permutations(nums, 2) do
    for x <- nums, y <- nums, x != y, do: [ x, y ]
  end

  defp permutations(nums, 3) do
    for x <- nums, y <- nums, z <- nums, x != y, x != z, do: [ x, y, z ]
  end

  defp find(nums, target) do
    Enum.find(nums, fn ns -> Enum.sum(ns) == 2020 end)
  end

  defp product(nums) do
    Enum.reduce(nums, &*/2)
  end
end
