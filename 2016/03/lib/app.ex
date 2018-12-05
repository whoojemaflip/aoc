defmodule App do

  def answer_one do
    get_data("puzzle_data.txt")
      |> count_possible_triangles
  end

  def answer_two do
    get_data("puzzle_data.txt")
      |> columns_to_rows
      |> count_possible_triangles
  end

  @doc """
  ## Examples
      iex> App.count_possible_triangles([[785, 516, 744], [272, 511, 358]])
      2
  """
  def count_possible_triangles(data) do
    data
      |> Enum.map(&(Triangles.valid?(&1)))
      |> count_of_possible
  end

  @doc """
  ## Examples
      iex> App.count_of_possible([{:ok, :valid}, {:ok, :invalid}, {:error, :invalid}])
      1
  """
  def count_of_possible(list), do: count_of_possible(list, 0)
  def count_of_possible([{:ok, :valid} | tail], acc), do: count_of_possible(tail, acc+1)
  def count_of_possible([{_, :invalid} | tail], acc), do: count_of_possible(tail, acc)
  def count_of_possible([], acc), do: acc

  @doc """
  Expects a filename of a whitespace seperated file that exists in the data dir

  ## Examples
      iex> App.get_data('test_one.txt')
      [[785, 516, 744], [272, 511, 358]]
  """
  def get_data(filename) do
    Path.join('data', filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
      |> Enum.map(&(parse_line(&1)))
  end

  @doc """
  ## Examples
      iex> App.columns_to_rows([[1,2,3], [1,2,3], [1,2,3]])
      [[1,1,1], [2,2,2], [3,3,3]]
  """
  def columns_to_rows(list), do: columns_to_rows(list, [])
  def columns_to_rows([[x1, y1, z1], [x2, y2, z2], [x3, y3, z3] | tail], out) do
    columns_to_rows(tail, out ++ [[x1, x2, x3]] ++ [[y1, y2, y3]] ++ [[z1, z2, z3]])
  end
  def columns_to_rows([], result), do: result


  @doc """
  ## Examples
      iex> App.parse_line("  785  516  744")
      [785, 516, 744]
  """
  def parse_line(str) do
    String.split(str) |> Enum.map(&(String.to_integer(&1)))
  end
end
