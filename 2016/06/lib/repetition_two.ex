defmodule RepetitionTwo do

  @doc """
    iex> RepetitionTwo.app("test.txt")
    "advent"
  """
  def app(filename) do
    data = get_file_data(filename)
    width = Enum.at(data, 0)
      |> String.codepoints
      |> Enum.count
    iterator(data, width)
  end

  def iterator(data, width), do: iterator(data, width - 1, "")
  def iterator(_, -1, chars), do: String.reverse(chars)
  def iterator(data, width, chars) do
    iterator(data, width - 1, chars <> least_common_character(data, width))
  end

  @doc """
    iex> RepetitionTwo.least_common_character(["ab", "ax", "df"], 0)
    "d"
  """
  def least_common_character(list, position), do: least_common_character(list, position, [])
  def least_common_character([], _, chars), do: find_least_frequent(chars)
  def least_common_character([ head | tail ], position, chars) do
    this_char = String.codepoints(head) |> Enum.at(position)
    least_common_character(tail, position, chars ++ [this_char])
  end

  @doc """
    iex> RepetitionTwo.find_least_frequent(["b", "b", "c"])
    "c"
  """
  def find_least_frequent(charlist) do
    Enum.group_by(charlist, &(&1))
      |> Enum.map(&(replace_with_count(&1)))
      |> less_frequentest
  end

  def less_frequentest(list), do: less_frequentest(list, 100, '')
  def less_frequentest([], _, char), do: char
  def less_frequentest([{key, value} | tail], top, char) do
    if value < top do
      less_frequentest(tail, value, key)
    else
      less_frequentest(tail, top, char)
    end
  end

  def replace_with_count({key, value}), do: {key, Enum.count(value)}

  def get_file_data(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end
end
