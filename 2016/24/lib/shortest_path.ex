defmodule ShortestPath do
  def part_1, do: load_graph("part1_graph.txt") |> brute_force
  def test_data, do: load_graph("test_graph.txt")

  @doc """
    iex> ShortestPath.test_data |> ShortestPath.brute_force
    {14, ["0", "4", "1", "2", "3"]}
  """
  def brute_force(graph) do
    graph
      |> nodes
      |> Enum.filter(fn(x) -> x != "0" end)
      |> permutations
      |> Enum.map(&(eval_path(["0"] ++ &1 ++ ["0"], graph)))
      |> Enum.min_by(fn({d, p}) -> d end)
  end

  @doc """
    iex> ShortestPath.eval_path(["0", "1", "2"], ShortestPath.test_data)
    {8, ["0", "1", "2"]}
  """
  def eval_path([h|t], graph), do: eval_path(t, graph, h, 0, [h|t])
  def eval_path([], _, _, distance, path), do: {distance, path}
  def eval_path([h|t], graph, prev, dist, path), do: eval_path(t, graph, h, dist + distance_between_nodes(graph, h, prev), path)

  @doc """
    iex> ShortestPath.permutations(["a", "b", "c"])
    [["a", "b", "c"], ["a", "c", "b"], ["b", "a", "c"], ["b", "c", "a"], ["c", "a", "b"], ["c", "b", "a"]]
  """
  def permutations([]), do: [[]]
  def permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h | t]
  end

  @doc """
    iex> ShortestPath.test_data |> ShortestPath.distance_between_nodes("3", "1")
    8
  """
  def distance_between_nodes([], _, _), do: :infinity
  def distance_between_nodes([h|t], a, b) do
    case h do
      {^a, ^b, d} -> d
      {^b, ^a, d} -> d
      _ -> distance_between_nodes(t, a, b)
    end
  end

  @doc """
    iex> ShortestPath.test_data |> ShortestPath.nodes
    ["0", "1", "2", "3", "4"]
  """
  def nodes(graph), do: nodes(graph, [])
  def nodes([], result), do: Enum.uniq(result) |> Enum.sort
  def nodes([{a, b, _}|t], result) do
    nodes(t, [a, b] ++ result)
  end

  @doc """
    ShortestPath.parse_line("2 -> 4 (10)")
    {"2", "4", 10)}
  """
  def parse_line(line) do
    r = ~r{\A(?<snode>\d+?) -> (?<enode>\d+?) \((?<dist>\d+?)\)\Z}
    %{"snode" => snode, "enode" => enode, "dist" => dist} = Regex.named_captures(r, line)
    {snode, enode, String.to_integer(dist)}
  end

  @doc """
    iex> ShortestPath.load_graph("test_graph.txt")
    [{"0", "3", 10}, {"1", "3", 8}, {"2", "3", 2}, {"3", "4", 8},
    {"0", "4", 2}, {"1", "4", 4}, {"2", "4", 10}, {"0", "2", 8},
    {"1", "2", 6}, {"0", "1", 2}]
  """
  def load_graph(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
      |> Enum.map(&(parse_line(&1)))
  end
end
