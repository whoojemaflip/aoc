defmodule Triangles do
  @doc """
  Call Triangles.valid? with an array of three numbers.

  In a valid triangle, the sum of any two sides must be larger than the remaining
  side. For example, the "triangle" [5, 10, 25] is impossible, because 5 + 10
  is not larger than 25.

  ## Examples
      iex> Triangles.valid?([5, 10, 25])
      {:ok, :invalid}
      iex> Triangles.valid?([10, 10, 15])
      {:ok, :valid}
      iex> Triangles.valid?([12, 123, 123, 345, 123])
      {:error, :invalid}
  """
  def valid?([x, y, z]) do
    [x, y, z] |> Enum.sort |> _valid?
  end

  def valid?(_), do: {:error, :invalid}

  defp _valid?([x, y, z]) when (x + y) > z, do: {:ok, :valid}
  defp _valid?([_, _, _]), do: {:ok, :invalid}
end
