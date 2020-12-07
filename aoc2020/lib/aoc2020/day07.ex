defmodule AoC2020.Day07 do
  @input "../../assets/day07_input.txt" |> Path.expand(__DIR__) |> File.read!()

  def part1 do
    build_graph()
    |> ancestors(:"shiny gold")
    |> MapSet.size()
  end

  def part2 do
    build_graph()
    |> count_children(:"shiny gold")
  end

  def build_graph do
    @input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.into(%{})
    |> build_parents()
  end

  def parse_line(line) do
    line
    |> String.split(" contain ")
    |> atomize_node_name()
    |> parse_children()
    |> (fn [ node, children_map ] -> { node, %{ children: children_map, parents: MapSet.new() } } end).()
  end

  def atomize_node_name([ node, children ]) do
    node
    |> String.replace(" bags", "")
    |> String.to_atom()
    |> (fn a -> [ a, children ] end).()
  end

  def parse_children([ node, "no other bags."]) do
    [ node, %{} ]
  end
  def parse_children([ node, children ]) do
    children
    |> String.replace(~r{\Wbags?\.?}, "")
    |> String.split(", ")
    |> Enum.map(&(String.split(&1, " ", parts: 2)))
    |> Enum.map(fn [ count, child ] -> { String.to_atom(child), count |> Integer.parse(10) |> elem(0) } end)
    |> Enum.into(%{})
    |> (fn cs -> [ node, cs ] end).()
  end

  def build_parents(nodes) do
    nodes
    |> Map.keys()
    |> Enum.reduce(nodes, &update_childrens_parents/2)
  end

  def update_childrens_parents(parent_key, nodes) do
    nodes
    |> Map.get(parent_key)
    |> Map.get(:children)
    |> Map.keys()
    |> Enum.reduce(nodes, fn (child_key, nodes) ->
      { _, new_nodes } = Map.get_and_update!(nodes, child_key, fn child_node ->
        { _, new_child_node } = Map.get_and_update!(child_node, :parents, fn parents_set ->
          { parents_set, MapSet.put(parents_set, parent_key) }
        end)
        { child_node, new_child_node }
      end)
      new_nodes
    end)
  end

  def ancestors(nodes, start_node) do
    nodes
    |> Map.get(start_node)
    |> Map.get(:parents, MapSet.new())
    |> _ancestors(nodes)
  end

  def _ancestors([], _), do: MapSet.new()
  def _ancestors(parents, nodes) do
    MapSet.union(parents, Enum.reduce(parents, MapSet.new(), fn p, set -> MapSet.union(set, ancestors(nodes, p)) end))
  end

  def count_children(nodes, start_node, quantity \\ 1) do
    direct_children = nodes |> Map.get(start_node) |> Map.get(:children)
    num_direct_children = direct_children |> Map.values() |> Enum.sum()
    Enum.reduce(Map.keys(direct_children), num_direct_children, fn child_node, sum -> (direct_children[child_node] * count_children(nodes, child_node)) + sum end)
  end

end
