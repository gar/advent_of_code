defmodule AoC2020.Day09 do

  @input "../../assets/day09_input.txt" |> Path.expand(__DIR__) |> File.read!()
  @test """
  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576
  """

  def part1 do
    load_input()
    |> windows(25)
    |> Enum.find(&badsum?/1)
    |> List.last()
  end

  def part2 do
    load_input()
    |> find_target(part1())
  end

  def load_input() do
    @input
    |> String.split("\n", trim: true)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&(elem(&1, 0)))
  end

  def windows(nums, preamble_len) do
    _windows(nums, preamble_len, [])
    |> Enum.reverse()
  end
  def _windows(nums, preamble_len, acc) when length(nums) < preamble_len+1, do: acc
  def _windows(nums, preamble_len, acc) do
    _windows(Enum.drop(nums, 1), preamble_len, [ Enum.take(nums, preamble_len+1) | acc ])
  end

  def badsum?(nums) do
    [ target | xs ] = Enum.reverse(nums)

    pairs(xs)
    |> Enum.map(&Enum.sum/1)
    |> Enum.any?(fn sum -> sum == target end)
    |> Kernel.not()
  end

  def pairs(nums), do: for x <- nums, y <- nums, x != y, do: [ x, y ]

  def find_target(nums, target) do
    2..length(nums)
    |> Stream.flat_map(&(Stream.chunk_every(nums, &1, 1, :discard)))
    |> Enum.find(fn ns -> Enum.sum(ns) == target end)
    |> Enum.min_max()
    |> Tuple.to_list()
    |> Enum.sum()
  end
end
