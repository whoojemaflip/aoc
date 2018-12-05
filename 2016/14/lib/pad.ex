defmodule Pad do
  defmacro is_enough({_, _, keys}) do
    length = Enum.count(keys || [])
    quote do: unquote(length) >= unquote(64)
  end

  def app do
    rainbow_table("yjdafjpo", 100000) |> key_search
  end

  def key_search(list), do: key_search(list, [])
  def key_search([], keys), do: IO.puts "Out of keys found #{Enum.count(keys)}"
  def key_search(_, keys) when is_enough(keys), do: keys
  def key_search([{i, md5}|tail], keys) do
    if is_key?(md5, Enum.take(tail, 1000)) do
      IO.puts "#{i}: #{md5}"
      key_search(tail, keys ++ [{i,  md5}])
    else
      key_search(tail, keys)
    end
  end

  @doc """
    iex> Pad.is_key?("e3f1814de333d3980", [{1, "adafe33333xcvdrg"}])
    true
  """
  def is_key?(md5, keys) do
    five_consecutive_letters?(keys, three_consecutive_letters(md5))
  end

  @doc """
    iex> Pad.five_consecutive_letters?([{1, "abcccccde"}], "c")
    true
    iex> Pad.five_consecutive_letters?([{1, "abcccccde"}], "a")
    false
  """
  def five_consecutive_letters?([], _), do: false
  def five_consecutive_letters?(_, nil), do: false
  def five_consecutive_letters?([{i, md5}|tail], char) do
    if five_char_matches?(char, md5) do
      true
    else
      five_consecutive_letters?(tail, char)
    end
  end

  @doc """
    iex> Pad.five_char_matches?("x", "xxxxx")
    true
    iex> Pad.five_char_matches?("x", "asdq234")
    false
  """
  def five_char_matches?(char, str) do
    regex = Regex.compile!("#{char}{5}")
    Regex.match?(regex, str)
  end

  @doc """
    iex> Pad.three_consecutive_letters("abdfgggsdfseg")
    "g"
    iex> Pad.three_consecutive_letters("abdfggsdfseg")
    nil
  """
  def three_consecutive_letters(str) do
    reg = ~r/(?<char>(.))\1\1/
    case Regex.named_captures(reg, str) do
      %{"char" => char} -> char
      nil -> nil
    end
  end

  def rainbow_table(salt, max), do: rainbow_table(salt, 0, max, [])
  def rainbow_table(_, min, max, result) when (min == max), do: result
  def rainbow_table(salt, min, max, result) do
    str = "#{salt}#{min}"
    rainbow_table(salt, min + 1, max, result ++ [{min, md5(str)}])
  end

  def md5(str), do: md5(str, 2016)
  def md5(str, -1), do: str
  def md5(str, count) do
    Base.encode16(:erlang.md5(str), case: :lower)
      |> md5(count - 1)
  end
end
