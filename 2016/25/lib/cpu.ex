defmodule Registers do
  defstruct pc: 0, a: 0, b: 0, c: 0, d: 0
end

defmodule Cpu do

  def run, do: run("data.txt")
  def run(filename) do
    memory = load(filename)
    (0..1000) |> Enum.each(fn(input) -> run(input, memory) end)
  end
  def run(input, memory) do
    IO.puts input
    exec(%Registers{a: input}, memory, [])
  end

  def exec(registers, memory, io), do: exec({registers, memory, io}, Enum.count(memory))
  def exec({registers, memory, io}, highmem) do
    if Enum.count(io) > 10 do
      if Enum.take(io, 10) == [0, 1, 0, 1, 0, 1, 0, 1, 0, 1] do
        IO.inspect io
        IO.puts "Success!"
        System.halt(0)
      else
        false
      end
    else
      if registers.pc >= highmem do
        IO.inspect registers
      else
        command_at(memory, registers.pc)
          |> exec_cmd({registers, memory, io})
          |> increment_program_counter
          |> exec(highmem)
      end
    end
  end

  def command_at(memory, address), do: Enum.at(memory, address)

  def increment_program_counter({%Registers{pc: pc, a: a, b: b, c: c, d: d}, memory, io}) do
    {%Registers{pc: pc + 1, a: a, b: b, c: c, d: d}, memory, io}
  end

  def exec_cmd(%{"ins" => "tgl", "arg1" => arg1}, {registers, memory}) do
    val = registers |> resolve_arg(arg1)
    address = registers.pc + val
    if address >= Enum.count(memory) do
      {registers, memory}
    else
      mem2 = togl(memory, address)
      {registers, mem2 |> mem_dump}
    end
  end

  def print_cmd(cmd, registers) do
    IO.inspect cmd
    IO.inspect registers
    cmd
  end

  def mem_dump(memory) do
    IO.inspect(memory)
    memory
  end

  def togl(memory, address) do
    case command_at(memory, address) do
      %{"ins" => "inc", "arg1" => arg1, "arg2" => ""} ->
        List.replace_at(memory, address, %{"ins" => "dec", "arg1" => arg1})
      %{"ins" => ins, "arg1" => arg1, "arg2" => ""} ->
        List.replace_at(memory, address, %{"ins" => "inc", "arg1" => arg1})
      %{"ins" => "jnz", "arg1" => arg1, "arg2" => arg2} ->
        List.replace_at(memory, address, %{"ins" => "cpy", "arg1" => arg1, "arg2" => arg2})
      %{"ins" => ins, "arg1" => arg1, "arg2" => arg2} ->
        List.replace_at(memory, address, %{"ins" => "jnz", "arg1" => arg1, "arg2" => arg2})
    end
  end

  def exec_cmd(%{"ins" => "jnz", "arg1" => arg1, "arg2" => arg2}, {registers, memory, io}) do
    comp = registers |> resolve_arg(arg1)
    val = registers |> resolve_arg(arg2)

    if comp != 0 do
      {set(registers, registers.pc + val - 1, "pc"), memory, io}
    else
      {registers, memory, io}
    end
  end

  def exec_cmd(%{"ins" => "cpy", "arg1" => arg1, "arg2" => arg2}, {registers, memory, io}) do
    val = registers |> resolve_arg(arg1)
    {set(registers, val, arg2), memory, io}
  end

  def exec_cmd(%{"ins" => "inc", "arg1" => reg}, {registers, memory, io}) do
    val = registers |> resolve_arg(reg)
    {set(registers, val + 1, reg), memory, io}
  end

  def exec_cmd(%{"ins" => "dec", "arg1" => reg}, {registers, memory, io}) do
    val = registers |> resolve_arg(reg)
    {set(registers, val - 1, reg), memory, io}
  end

  def exec_cmd(%{"ins" => "out", "arg1" => arg1}, {registers, memory, io}) do
    val = registers |> resolve_arg(arg1)
    {registers, memory, io ++ [val]}
  end

  def set(%Registers{pc: pc, a: _, b: b, c: c, d: d}, val, "a"), do: %Registers{pc: pc, a: val, b: b, c: c, d: d}
  def set(%Registers{pc: pc, a: a, b: _, c: c, d: d}, val, "b"), do: %Registers{pc: pc, a: a, b: val, c: c, d: d}
  def set(%Registers{pc: pc, a: a, b: b, c: _, d: d}, val, "c"), do: %Registers{pc: pc, a: a, b: b, c: val, d: d}
  def set(%Registers{pc: pc, a: a, b: b, c: c, d: _}, val, "d"), do: %Registers{pc: pc, a: a, b: b, c: c, d: val}
  def set(%Registers{pc: _, a: a, b: b, c: c, d: d}, val, "pc"), do: %Registers{pc: val, a: a, b: b, c: c, d: d}

  def resolve_arg(registers, "a"), do: registers.a
  def resolve_arg(registers, "b"), do: registers.b
  def resolve_arg(registers, "c"), do: registers.c
  def resolve_arg(registers, "d"), do: registers.d
  def resolve_arg(_, arg), do: String.to_integer(arg)

  def load(filename), do: get_file_data(filename) |> parse

  @doc """
    iex> Cpu.parse(["jnz c -2"])
    [%{"ins" => "jnz", "arg1" => "c", "arg2" => "-2"}]
  """
  def parse(data), do: parse(data, [])
  def parse([], result), do: Enum.reverse(result)
  def parse([head|tail], result) do
    regex = ~r{\A(?<ins>[a-z]+?) (?<arg1>[a-z0-9\-]+?)( (?<arg2>[a-z0-9-]+?))?\Z}
    parse(tail, [Regex.named_captures(regex, head) | result])
  end

  def get_file_data(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end
end
