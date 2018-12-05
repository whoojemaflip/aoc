defmodule Bots do

  def go, do: run("data.txt") |> Enum.map(&(print_state(&1)))

  def run(filename) do
    instructions = get_file_data(filename) |> parse
    bot_holdings = initial_state(instructions)
    iterate_chip_distribution(bot_holdings, bot_instructions(instructions))
  end

  @doc """
    %{bot_1: %{id: :bot_1, state: [3]}, bot_2: {id: :bot_2, state: [2, 5]}}
    %{bot_0: %{id: :bot_0, low: :output_2, high: :output_0}, bot_2: %{id: :bot_2, low: :bot_1, high: :bot_0}}

  """
  def iterate_chip_distribution(state, instructions) do
    case first_bot_with_two_microchips(state) do
      %{id: bot, state: [low_value, high_value]} ->
        IO.puts "#{bot} -> #{low_value} : #{high_value}"
        %{id: ^bot, low: low_receiver, high: high_receiver} = Map.get(instructions, bot)
        state
          |> distribute(low_receiver, low_value)
          |> distribute(high_receiver, high_value)
          |> Map.put(bot, %{id: bot, state: []})
          |> iterate_chip_distribution(instructions)
      :done ->
        state
    end
  end

  def print_state({_, %{id: thing, state: state}}) do
    IO.puts "#{thing} -> #{print_state(state)}"
  end
  def print_state([]), do: ""
  def print_state([head | tail]) do
    IO.puts(head)
    print_state(tail)
  end

  @doc """
    iex> Bots.distribute(%{output_1: %{id: :output_1, state: [23]}}, :output_1, 3)
    %{output_1: %{id: :output_1, state: [3, 23]}}
  """
  def distribute(state, receiver, value) do
    Map.update(state, receiver, new_receiver(receiver, value), &(update_state(&1, value)))
  end

  @doc """
    iex> Bots.first_bot_with_two_microchips(%{bot_1: %{id: :bot_1, state: [3]}, bot_2: %{id: :bot_2, state: [2, 5]}})
    %{id: :bot_2, state: [2, 5]}
  """
  def first_bot_with_two_microchips(bot_state) when is_map(bot_state) do
    Map.values(bot_state) |> first_bot_with_two_microchips
  end
  def first_bot_with_two_microchips([%{id: id, state: [x, y]} | tail]), do: %{id: id, state: [x, y]}
  def first_bot_with_two_microchips([head | tail]), do: first_bot_with_two_microchips(tail)
  def first_bot_with_two_microchips([]), do: :done

  # %{id: :bot_1, low: :output_1, high: :bot_0}
  def bot_instructions(instructions), do: bot_instructions(instructions, %{})
  def bot_instructions([], result), do: result
  def bot_instructions([%{id: bot, low: low, high: high} | tail], output) do
    bot_instructions(tail, Map.put(output, bot, %{id: bot, low: low, high: high}))
  end
  def bot_instructions([_ | tail], result), do: bot_instructions(tail, result)

  @doc """
    iex> Bots.initial_state(Bots.get_file_data("test.txt") |> Bots.parse)
    %{bot_1: %{id: :bot_1, state: [3]}, bot_2: %{id: :bot_2, state: [2, 5]}}
  """
  def initial_state(instructions), do: initial_state(instructions, %{})
  def initial_state([], result), do: result
  def initial_state([%{value: value, to: bot} | tail], result) do
    r2 = Map.update(result, bot, new_receiver(bot, value), &(update_state(&1, value)))
    initial_state(tail, r2)
  end
  def initial_state([_|tail], result), do: initial_state(tail, result)

  def new_receiver(id, value), do: %{id: id, state: [value]}
  def update_state(%{id: bot, state: state}, new_value) do
    %{id: bot, state: Enum.sort(state ++ [new_value])}
  end

  def parse(list) when is_list(list), do: parse(list, [])
  def parse([], result), do: result
  def parse([head|tail], result), do: parse(tail, result ++ [parse(head)])

  @doc """
    iex> Bots.parse("value 5453 goes to bot 21232")
    %{value: 5453, to: :bot_21232}
  """
  def parse("value " <> instruction) do
    r = ~r/(\d+?) goes to bot (\d+?)$/
    [_, value, bot] = Regex.run(r, instruction)
    %{value: String.to_integer(value), to: bot_name(bot)}
  end

  @doc """
    iex> Bots.parse("bot 21232 gives low to bot 123123 and high to bot 456456456")
    %{id: :bot_21232, low: :bot_123123, high: :bot_456456456}
    iex> Bots.parse("bot 1 gives low to output 1 and high to bot 0")
    %{id: :bot_1, low: :output_1, high: :bot_0}
    iex> Bots.parse("bot 0 gives low to output 2 and high to output 0")
    %{id: :bot_0, low: :output_2, high: :output_0}
  """
  def parse("bot " <> instruction) do
    r = ~r/(\d+?) gives low to (bot|output) (\d+?) and high to (bot|output) (\d+?)$/
    [_, bot, low_receiver, low_value, high_receiver, high_value] = Regex.run(r, instruction)
    %{ id: bot_name(bot), low: name(low_receiver, low_value), high: name(high_receiver, high_value) }
  end

  def name("output", id), do: output_name(id)
  def name("bot", id), do: bot_name(id)
  def output_name(output_id), do: String.to_atom("output_#{output_id}")
  def bot_name(bot_id), do: String.to_atom("bot_#{bot_id}")

  def get_file_data(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end
end
