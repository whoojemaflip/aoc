class Spinlock
  def initialize(steps)
    @steps = steps
    @buffer = [0]
    @position = 0
    @value = 1
  end

  def exec
    2017.times { step }
    @buffer[@buffer.index(2017) + 1]
  end

  def step
    @position = (((@steps % @buffer.size) + @position) % @buffer.size) + 1
    @buffer.insert(@position, @value)
    @value += 1
  end
end

puts Spinlock.new(335).exec
