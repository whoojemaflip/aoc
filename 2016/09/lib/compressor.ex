defmodule Compressor do

  @doc """
    iex> Compressor.decompressed_length("test.txt")
    18
  """
  def decompressed_length(filename) do
    filedata(filename)
      |> decompress
      |> remove_whitespace_chars
      |> String.length
  end

  @doc """
    iex> Compressor.remove_whitespace_chars("abc defabc def ")
    "abcdefabcdef"
  """
  def remove_whitespace_chars(text) do
    String.split(text) |> Enum.join
  end

  @doc """
    iex> Compressor.decompress("ADVENT")
    "ADVENT"
    iex> Compressor.decompress("A(1x5)BC")
    "ABBBBBC"
    iex> Compressor.decompress("(3x3)XYZ")
    "XYZXYZXYZ"
    iex> Compressor.decompress("A(2x2)BCD(2x2)EFG")
    "ABCBCDEFEFG"
    iex> Compressor.decompress("(6x1)(1x3)A")
    "(1x3)A"
    iex> Compressor.decompress("X(8x2)(3x3)ABCY")
    "X(3x3)ABC(3x3)ABCY"
  """
  def decompress(text) do
    chunks(text)
      |> Enum.map(&(expand_chunk(&1)))
      |> Enum.join
  end

  @doc """
    iex> Compressor.expand_chunk("ABC")
    "ABC"
    iex> Compressor.expand_chunk({5, "B"})
    "BBBBB"
  """
  def expand_chunk(<< string::binary >>), do: string
  def expand_chunk({n, << s::binary >>}), do: expand_chunk({n, s}, "")
  def expand_chunk({0, _}, result), do: result
  def expand_chunk({multipler, << string::binary >>}, result) do
    expand_chunk({multipler - 1, string}, result <> string)
  end

  @doc """
    iex> Compressor.chunks("A(2x2)BCD(2x2)EFG")
    ["A", {2, "BC"}, "D", {2, "EF"}, "G"]
  """
  def chunks(text), do: chunks(text, [])
  def chunks(<<>>, result), do: result
  def chunks(text, result) do
    {t1, chunk} = next_chunk(text)
    chunks(t1, result ++ [chunk])
  end

  @doc """
    iex> Compressor.next_chunk("ADVENT")
    {"", "ADVENT"}
    iex> Compressor.next_chunk("A(1x5)BC")
    {"(1x5)BC", "A"}
    iex> Compressor.next_chunk("(1x5)BC")
    {"C", {5, "B"}}
  """
  def next_chunk(text), do: next_chunk(text, "")
  def next_chunk(<<>>, result), do: {"", result}
  def next_chunk("(" <> remainder, ""), do: next_compressed_chunk(remainder)
  def next_chunk("(" <> remainder, result), do: {"(" <> remainder, result}
  def next_chunk(<< char::utf8, remainder::binary >>, result), do: next_chunk(remainder, result <> << char >>)

  @doc """
    iex> Compressor.next_compressed_chunk("1x5)BC")
    {"C", {5, "B"}}
  """
  def next_compressed_chunk(text) do
    {t1, length} = _get_chunk_length(text)
    {t2, multipler} = _get_chunk_multipler(t1)
    {t3, compressed_text} = _next_n_characters(t2, length)
    {t3, {multipler, compressed_text}}
  end

  @doc """
    iex> Compressor._next_n_characters("ABCDEF", 4)
    {"EF", "ABCD"}
  """
  def _next_n_characters(text, length), do: _next_n_characters(text, length, "")
  def _next_n_characters(remainder, 0, result), do: {remainder, result}
  def _next_n_characters(<<>>, _, result), do: {"", result}
  def _next_n_characters(<< char::utf8, remainder::binary >>, n, result) do
    _next_n_characters(remainder, n - 1, result <> << char >>)
  end

  @doc """
    iex> Compressor._get_chunk_length("100x125)ABC")
    {"125)ABC", 100}
  """
  def _get_chunk_length(text), do: _get_chunk_length(text, "")
  def _get_chunk_length("x" <> remainder, << chunk_length::binary >>) do
    {remainder, String.to_integer(chunk_length)}
  end
  def _get_chunk_length(<< char::utf8, remainder::binary >>, << chunk_length::binary >>) do
    _get_chunk_length(remainder, chunk_length <> << char >>)
  end

  @doc """
    iex> Compressor._get_chunk_multipler("10)ABC")
    {"ABC", 10}
  """
  def _get_chunk_multipler(text), do: _get_chunk_multipler(text, "")
  def _get_chunk_multipler(")" <> remainder, << multipler::binary >>) do
    {remainder, String.to_integer(multipler)}
  end
  def _get_chunk_multipler(<< char::utf8, remainder::binary >>, << multipler::binary >>) do
    _get_chunk_multipler(remainder, multipler <> << char >>)
  end

  def filedata(filename) do
    Path.join("data", filename) |> File.read!
  end
end
