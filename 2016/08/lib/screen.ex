defmodule Screen do

  @doc """
    iex> Screen.run_program("test.txt", 4, 4)
    [[false, true, false, true], [true, true, false, false], [true, false, false, false], [false, false, false, false]]
  """
  def run_program(filename, width, height) do
    {_, output} = get_file_data(filename)
      |> Enum.map_reduce(
        new(width, height),
        fn(line, scr) -> {line, exec(line, scr)} end
      )

    output
  end

  @doc """
    iex> Screen.count_pixels([[false, true], [true, false]])
    2
  """
  def count_pixels(screen) do
    screen
      |> Enum.map(&(count_row_pixels(&1)))
      |> Enum.reduce(0, &(&1 + &2))
  end

  def count_row_pixels(row) do
    Enum.filter(row, fn(bool) -> bool end) |> Enum.count
  end

  @doc """
    iex> Screen.transpose([[1, 2, 3, 4], [5, 6, 7, 8]])
    [[1, 5], [2, 6], [3, 7], [4, 8]]
    iex> Screen.transpose([[1, 5], [2, 6], [3, 7], [4, 8]])
    [[1, 2, 3, 4], [5, 6, 7, 8]]
  """
  def transpose(screen) do
    number_of_columns = Enum.at(screen, 0) |> Enum.count
    Enum.map(0..number_of_columns - 1, fn(x) -> column_to_row(screen, x) end)
  end

  @doc """
    iex> Screen.column_to_row([[1, 2, 3], [4, 5, 6]], 0)
    [1, 4]
  """
  def column_to_row(screen, x) do
    Enum.map(screen, fn(row) -> Enum.at(row, x) end)
  end

  @doc """
    iex> Screen.rect(Screen.new(4, 3), 3, 2)
    [[true, true, true, false], [true, true, true, false], [false, false, false, false]]
  """
  def rect(screen, _, 0), do: screen
  def rect(screen, x, y) do
    new_row = Enum.at(screen, y - 1) |> fill_row(x)
    List.replace_at(screen, y - 1, new_row) |> rect(x, y - 1)
  end

  @doc """
    iex> Screen.fill_row([false, false, false], 2)
    [true, true, false]
  """
  def fill_row(row, 0), do: row
  def fill_row(row, x) do
    List.replace_at(row, x - 1, true) |> fill_row(x - 1)
  end

  @doc """
    iex> Screen.rotate(Screen.new(3, 3) |> Screen.rect(2, 2), :row, 1, 1)
    [[true, true, false], [false, true, true], [false, false, false]]
  """
  def rotate(screen, :row, index, value) do
    row = Enum.at(screen, index)
    List.replace_at(screen, index, rotate_row(row, value, :right))
  end

  @doc """
    iex> Screen.rotate([[1, 2, 3], [4, 5, 6], [7, 8, 9]], :column, 1, 1)
    [[1, 8, 3], [4, 2, 6], [7, 5, 9]]
    iex> Screen.rotate([[true, true], [false, false]], :column, 0, 1)
    [[false, true], [true, false]]
  """
  def rotate(screen, :column, index, value) do
    screen
      |> transpose
      |> rotate(:row, index, value)
      |> transpose
  end

  @doc """
    iex> Screen.rotate_row([true, false, false], 2, :right)
    [false, false, true]
  """
  def rotate_row(row, 0, :right), do: row
  def rotate_row(row, count, :right) do
    width = Enum.count(row) - 1
    Enum.map(0..width, &(rotate_pixel(row, &1, :right)))
      |> rotate_row(count - 1, :right)
  end

  @doc """
    iex> Screen.rotate_pixel([false, false, true], 0, :right)
    true
    iex> Screen.rotate_pixel([false, false, true], 1, :right)
    false
    iex> Screen.rotate_pixel([false, false, true], 2, :right)
    false
  """
  def rotate_pixel(row, i, :right) do
    width = Enum.count(row) - 1
    if i == 0 do
      Enum.at(row, width)
    else
      Enum.at(row, (i - 1))
    end
  end

  def print(screen) do
    IO.puts("\n")
    screen
      |> Enum.map(&(render_row(&1)))
      |> Enum.each(&(IO.puts(&1)))
    screen
  end

  @doc """
    iex> Screen.render_row([false, true, "x"])
    ".#x"
  """
  def render_row(row) do
    Enum.map(row, fn(bool) -> render_pixel(bool) end) |> Enum.join
  end

  @doc """
    iex> Screen.render_pixel(true)
    "#"
    iex> Screen.render_pixel(false)
    "."
    iex> Screen.render_pixel("D")
    "D"
  """
  def render_pixel(bool) do
    if(bool == true) do
      "#"
    else
      if(bool == false) do
        "."
      else
        bool
      end
    end
  end

  @doc """
    iex> Screen.new(1, 3)
    [[false], [false], [false]]
    iex> Screen.new(3, 2)
    [[false, false, false], [false, false, false]]
  """
  def new(width, height) do
    Enum.map(1..height, fn(_) -> new_row(width) end)
  end

  @doc """
    iex> Screen.new_row(4)
    [false, false, false, false]
  """
  def new_row(width) do
    Enum.map(1..width, fn(_) -> false end)
  end

  @doc """
    iex> Screen.exec("rotate column x=0 by 1", Screen.new(2, 2) |> Screen.rect(1, 1))
    [[false, false], [true, false]]
  """
  def exec(line, screen) do
    tokens = String.split(line)
    command = Enum.at(tokens, 0)
    case command do
      "rect" -> # rect 2x2
        [x, y] = Enum.at(tokens, 1) |> String.split("x") |> Enum.map(&(String.to_integer(&1)))
        rect(screen, x, y)
      "rotate" -> # rotate row y=0 by 10
        index = Enum.at(tokens, 2) |> String.split("=") |> Enum.at(1) |> String.to_integer
        row_col = if (Enum.at(tokens, 1) == "row"), do: :row, else: :column
        value = Enum.at(tokens, 4) |> String.to_integer
        rotate(screen, row_col, index, value)
    end
  end

  def get_file_data(filename) do
    Path.join("data", filename)
      |> File.read!
      |> String.split("\n")
      |> Enum.filter(fn(line) -> line != "" end)
  end
end
