defmodule Grid do

  # 1043
  def part_1, do: load("data.txt") |> viable_pairs

  @doc """
    iex> Grid.pairs([1,2,3])
    [[3, 1], [3, 2], [2, 3], [2, 1], [1, 2], [1, 3]]
  """
  def pairs(list), do: pairs(list, Enum.count(list), [])
  def pairs(list, 0, result), do: result
  def pairs([h|t], iterations, result) do
    pairs t ++ [h], iterations - 1, Enum.map(t, fn(x) -> [h, x] end) ++ result
  end

  def viable_pairs(nodes) do
    pairs(nodes)
      |> Enum.filter(&(node_a_not_empty(&1)))
      |> Enum.filter(&(node_a_data_fits_on_b(&1)))
      |> Enum.count
  end

  @doc """
    iex> Grid.node_a_data_fits_on_b([%{x: 0, y: 0, size: 85, used: 64, avail: 21}, %{x: 0, y: 1, size: 92, used: 64, avail: 65}])
    true
    iex> Grid.node_a_data_fits_on_b([%{x: 0, y: 0, size: 85, used: 64, avail: 21}, %{x: 0, y: 1, size: 92, used: 23, avail: 65}])
    true
  """
  def node_a_data_fits_on_b([a, b]) do
    a.used <= b.avail
  end

  @doc """
    iex> Grid.node_a_not_empty([%{x: 0, y: 0, size: 85, used: 64, avail: 21}, nil])
    true
    iex> Grid.node_a_not_empty([%{x: 0, y: 0, size: 85, used: 0, avail: 21}, nil])
    false
  """
  def node_a_not_empty([%{x: _, y: _, size: _, used: 0, avail: _}, _]), do: false
  def node_a_not_empty(_), do: true

  @doc """
    iex> Grid.load("test.txt")
    [%{x: 0, y: 0, size: 85, used: 64, avail: 21}, %{x: 0, y: 1, size: 92, used: 64, avail: 28}]
  """
  def load(filename) do
    get_file_data(filename) |> Enum.map(&(parse(&1))) |> Enum.filter(fn(x) -> x != nil end)
  end

  @doc """
    iex> Grid.parse("/dev/grid/node-x0-y0     85T   64T    21T   75%")
    %{x: 0, y: 0, size: 85, used: 64, avail: 21}
  """
  def parse(line) do
    regex = ~r{\A.dev.grid.node-x(?<x>\d+?)-y(?<y>\d+?)\W+(?<size>\d+?)T\W*(?<used>\d+?)T\W*(?<avail>\d+?)T\W*\d+\%\Z}
    case Regex.named_captures(regex, line) do
      nil -> nil
      data ->
        x = data["x"] |> String.to_integer
        y = data["y"] |> String.to_integer
        size = data["size"] |> String.to_integer
        used = data["used"] |> String.to_integer
        avail = data["avail"] |> String.to_integer
        %{x: x, y: y, size: size, used: used, avail: avail}
    end
  end

  def get_file_data(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end
end
