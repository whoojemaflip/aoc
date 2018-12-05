defmodule ElfTest do
  use ExUnit.Case
  doctest Elf

  test "setup" do
    assert Elf.setup(3) == [1,2,3]
  end

  test "opposite" do
    assert Elf.opposite(1, 5) == 3
    assert Elf.opposite(2, 4) == 4
    assert Elf.opposite(3, 3) == 1
    assert Elf.opposite(1, 2) == 2
  end
end
