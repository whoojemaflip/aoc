defmodule Obscurity do
  @doc """
  ## Example
      iex> Obscurity.sum_of_real_sector_ids("test_one.txt")
      300
  """
  def sum_of_real_sector_ids(filename) do
    get_file_data(filename)
      |> Enum.map(&(real?(&1)))
      |> Enum.reduce(fn({x, _}, acc) -> x + acc end)
  end

  def get_file_data(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end

  def real_names(filename) do
    get_file_data(filename)
      |> Enum.map(&(real?(&1)))
      |> Enum.filter(fn({x, _}) -> x > 0 end)
      |> Enum.map(&(deshift(&1)))
      |> Enum.each(&(print_line(&1)))
  end

  def print_line({id, word}), do: IO.puts "#{word} - #{id}"

  @doc """
  ## Example
      iex> Obscurity.deshift({2, "abc"})
      {2, "cde"}
  """
  def deshift({id, word}), do: deshift({id, word}, id)
  def deshift({0, word}, id), do: {id, word}
  def deshift({rotations, word}, id), do:  deshift({rotations - 1, rotate(word)}, id)

  @doc """
  ## Example
      iex> Obscurity.rotate("abcxyz")
      "bcdyza"
  """
  def rotate(str) do
    List.Chars.to_char_list(str)
      |> Enum.map(&(_rotate(&1)))
      |> Kernel.to_string
  end

  def _rotate(char) do
    if char == 122 do
      'a'
    else
      char + 1
    end
  end

  @doc """
  ## Example
      iex> Obscurity.real?("aaaaa-bbb-z-y-x-123[abxyz]")
      {123, "aaaaa-bbb-z-y-x"}
      iex> Obscurity.real?("a-b-c-d-e-f-g-h-987[abcde]")
      {987, "a-b-c-d-e-f-g-h"}
      iex> Obscurity.real?("not-a-real-room-404[oarel]")
      {404, "not-a-real-room"}
      iex> Obscurity.real?("totally-real-room-200[decoy]")
      {0, ""}
  """
  def real?(str), do: _real?(String.reverse(str))
  def _real?("]" <> <<checksum::bytes-size(5)>> <> "[" <> <<sector::bytes-size(3)>> <> "-" <> encrypted_name) do
    sector_id = String.reverse(sector) |> String.to_integer
    case checksum?(encrypted_name, String.reverse(checksum)) do
      true -> {sector_id, String.reverse(encrypted_name)}
      false -> {0, ""}
    end
  end

  @doc """
  ## Example
      iex> Obscurity.checksum?("aaaaa-bbb-z-y-x", "abxyz")
      true
      iex> Obscurity.checksum?("foo", "bar")
      false
  """
  def checksum?(str, checksum) do
    String.equivalent?(create_checksum(str), checksum)
  end

  @doc """
  ## Example
      iex> Obscurity.create_checksum("aaaaa-bbb-z-y-x")
      "abxyz"
      iex> Obscurity.create_checksum("a-b-c-d-e-f-g-h")
      "abcde"
      iex> Obscurity.create_checksum("not-a-real-room")
      "oarel"
      iex> Obscurity.create_checksum("totally-real-room")
      "loart"
  """
  def create_checksum(str) do
    String.codepoints(str)
      |> Enum.filter(fn(str) -> str != "-" end)
      |> Enum.sort
      |> Enum.chunk_by(&(&1))
      |> sort_by_length_then_value
      |> Enum.take(5)
      |> Enum.map(fn(list) -> Enum.take(list, 1) end)
      |> Enum.join
  end


  @doc """
  ## Example
      iex> Obscurity.sort_by_length_then_value([["a"], ["b", "b"]])
      [["b", "b"], ["a"]]
      iex> Obscurity.sort_by_length_then_value([["a", "a"], ["b", "b"]])
      [["a", "a"], ["b", "b"]]
      iex> Obscurity.sort_by_length_then_value([["a", "a"], ["b"]])
      [["a", "a"], ["b"]]
  """
  def sort_by_length_then_value(list) do
    Enum.sort(list, &_sorter/2)
  end

  @doc """
    The function should compare two arguments, and return false if the first
    argument follows the second one.

    I.E. the most common letters in the encrypted name, in order,
    with ties broken by alphabetization.

  ## Example
      iex> Obscurity._sorter(["a"], ["b", "b"])
      false
  """
  def _sorter(list_one, list_two) do
    one_is_larger = Enum.count(list_one) > Enum.count(list_two)
    same_size = Enum.count(list_one) == Enum.count(list_two)
    one_is_first = Enum.take(list_one, 1) < Enum.take(list_two, 1)

    one_is_larger || (same_size && one_is_first)
  end
end
