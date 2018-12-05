class Keypad
  def initialize
    @x = 1
    @y = 1
  end

  def pad
    [
      [1,2,3],
      [4,5,6],
      [7,8,9]
    ]
  end

  def num
    pad[@y][@x]
  end

  def num_xy(x, y)
    pad[y][x]
  end

  def move(dir)
    case dir
    when 'U'
      @y -= 1 if valid_option?(@x, @y-1)
    when 'D'
      @y += 1 if valid_option?(@x, @y+1)
    when 'L'
      @x -= 1 if valid_option?(@x-1, @y)
    when 'R'
      @x += 1 if valid_option?(@x + 1, @y)
    end
  end

  def door_code(str)
    instructions = str.split("\n")
    code = []

    instructions.each do |ins|
      ins.split("").each { |i| move(i) }
      code << num_xy(@x, @y)
    end

    code
  end

  def valid_option?(x, y)
    x >= 0 && y >= 0 && x <= 2 && y <= 2
  end
end

