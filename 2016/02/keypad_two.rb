require_relative 'keypad'

class KeypadTwo < Keypad
  def initialize
    @x = 0
    @y = 2
  end

  def pad
    [
      [' ', ' ', '1', ' ', ' '],
      [' ', '2', '3', '4', ' '],
      ['5', '6', '7', '8', '9'],
      [' ', 'A', 'B', 'C', ' '],
      [' ', ' ', 'D', ' ', ' '],
    ]
  end

  def valid_option?(x, y)
    x >= 0 &&
      y >= 0 &&
      x <= 4 &&
      y <= 4 &&
      num_xy(x, y) != ' '
  end
end
