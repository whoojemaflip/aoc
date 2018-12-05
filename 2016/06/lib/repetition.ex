defmodule Repetition do

  @doc """
    iex> Repetition.app("test.txt")
    "easter"
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
    iterator(data, width - 1, chars <> common_character(data, width))
  end

  @doc """
    iex> Repetition.common_character(["ab", "ax", "df"], 0)
    "a"
  """
  def common_character(list, position), do: common_character(list, position, [])
  def common_character([], _, chars), do: find_most_frequent(chars)
  def common_character([ head | tail ], position, chars) do
    this_char = String.codepoints(head) |> Enum.at(position)
    common_character(tail, position, chars ++ [this_char])
  end

  @doc """
    iex> Repetition.find_most_frequent(["b", "b", "c"])
    "b"
  """
  def find_most_frequent(charlist) do
    Enum.group_by(charlist, &(&1))
      |> Enum.map(&(replace_with_count(&1)))
      |> frequentest
  end

  def frequentest(list), do: frequentest(list, 0, '')
  def frequentest([], _, char), do: char
  def frequentest([{key, value} | tail], top, char) do
    if value > top do
      frequentest(tail, value, key)
    else
      frequentest(tail, top, char)
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
