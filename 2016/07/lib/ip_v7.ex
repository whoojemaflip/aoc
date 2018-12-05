defmodule IpV7 do
# You would also like to know which IPs support SSL (super-secret listening).

# An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in
# the supernet sequences (outside any square bracketed sections), and a corresponding
# Byte Allocation Block, or BAB, anywhere in the hypernet sequences. An ABA is any three-character
# sequence which consists of the same character twice with a different character between them, such as xyx
# or aba. A corresponding BAB is the same characters but in reversed positions: yxy and bab, respectively.

# For example:

# aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets).
# xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
# aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different).
# zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap).
# How many IPs in your puzzle input support SSL?


  @doc """
    iex> IpV7.aba("aba")
    ["aba"]
    iex> IpV7.aba("aaa")
    []
    iex> IpV7.aba("aaabab")
    ["aba", "bab"]
  """
  def aba(str), do: aba(str, [])
  def aba(str, results) do
    sub_string = first_three_chars(str)
    remainder = String.slice(str, 1, 9999)

    if reverseable?(sub_string) && different_characters?(sub_string) do
      aba(remainder, results ++ [sub_string])
    else
      if empty_string?(sub_string) do
        results
      else
        aba(remainder, results)
      end
    end
  end

  def first_three_chars(str) do
    if String.length(str) >= 3 do
      String.slice(str, 0, 3)
    else
      ""
    end
  end

  @doc """
    iex> IpV7.calculate_bab("aba")
    "bab"
  """
  def calculate_bab(aba) do
    str = String.codepoints(aba)
    Enum.at(str, 1) <> Enum.at(str, 0) <> Enum.at(str, 1)
  end

  @doc """
    iex> IpV7.ssl?("aba[bab]xyz")
    true
    iex> IpV7.ssl?("xyx[xyx]xyx")
    false
    iex> IpV7.ssl?("aaa[kek]eke")
    true
    iex> IpV7.ssl?("zazbz[bzb]cdb")
    true
  """
  def ssl?(str) do
    {supernets, hypernets} = parse(str)

    abas = Enum.map(supernets, &(aba(&1))) |> Enum.concat
    babs = Enum.map(abas, &(calculate_bab(&1)))
    _or(Enum.map(hypernets, &(String.contains?(&1, babs))))
  end

  @doc """
    iex> IpV7.count_ssl("test_2.txt")
    2
  """
  def count_ssl(filename) do
    get_file_data(filename)
      |> Enum.map(&(ssl?(&1)))
      |> Enum.filter(fn(bool) -> bool end)
      |> Enum.count
  end

  @doc """
    iex> IpV7.count_tls("test.txt")
    2
  """
  def count_tls(filename) do
    get_file_data(filename)
      |> Enum.map(&(tls?(&1)))
      |> Enum.filter(fn(bool) -> bool end)
      |> Enum.count
  end

  @doc """
    iex> IpV7.tls?("abba[mnop]qrst") # supports TLS (abba outside square brackets).
    true
    iex> IpV7.tls?("abcd[bddb]xyyx") # does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
    false
    iex> IpV7.tls?("aaaa[qwer]tyui") # does not support TLS (aaaa is invalid; the interior characters must be different).
    false
    iex> IpV7.tls?("ioxxoj[asdfgh]zxcvbn") # supports TLS (oxxo is outside square brackets, even though it's within a larger string).
    true
  """
  def tls?(str) do
    {parts, hypernets} = parse(str)

    _or(parts |> Enum.map(&(abba?(&1)))) && !_or(hypernets |> Enum.map(&(abba?(&1))))
  end

  @doc """
    iex> IpV7._or([false, false, true, false])
    true
    iex> IpV7._or([false, false])
    false
  """
  def _or(list), do: _or(list, false)
  def _or([], result), do: result
  def _or([head | tail], result), do: _or(tail, head || result)

  @doc """
    iex> IpV7.parse("abba[mnop]qrst")
    {["abba", "qrst"], ["mnop"]}

    iex> IpV7.parse("abba[mnop]qrst[asdasd]asss")
    {["abba", "qrst", "asss"], ["mnop", "asdasd"]}
  """
  def parse(str), do: parse(str, "", [], [], false)
  def parse("", str, parts, hypernets, _), do: {parts ++ [str], hypernets}
  def parse(str, working_str, parts, hypernets, in_hypernet) do
    char = String.first(str)
    remainder = String.slice(str, 1, 99999)
    if char == "[" do
      parse(remainder, "", parts ++ [working_str], hypernets, true)
    else
      if char == "]" do
        parse(remainder, "", parts, hypernets ++ [working_str], false)
      else
        parse(remainder, working_str <> char, parts, hypernets, in_hypernet)
      end
    end
  end

  @doc """
    iex> IpV7.abba?("abba")
    true
    iex> IpV7.abba?("aaaa")
    false
    iex> IpV7.abba?("qwds")
    false
    iex> IpV7.abba?("asddsa")
    true
  """
  def abba?(str) do
    sub_string = first_four_chars(str)

    if reverseable?(sub_string) && different_characters?(sub_string) do
      true
    else
      if empty_string?(sub_string) do
        false
      else
        abba?(String.slice(str, 1, 9999))
      end
    end
  end


  def first_four_chars(str) do
    if String.length(str) >= 4 do
      String.slice(str, 0, 4)
    else
      ""
    end
  end

  @doc """
    iex> IpV7.empty_string?("")
    true
    iex> IpV7.empty_string?("asd")
    false
  """
  def empty_string?(str), do: str == ""

  @doc """
    iex> IpV7.reverseable?("abba")
    true
    iex> IpV7.reverseable?("asd")
    false
  """
  def reverseable?(str), do: str == String.reverse(str)

  @doc """
    iex> IpV7.different_characters?("aaa")
    false
    iex> IpV7.different_characters?("abab")
    true
  """
  def different_characters?(str) do
    String.codepoints(str) |> Enum.uniq |> Enum.count > 1
  end

  def get_file_data(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end
end
