class Spinlock
  def initialize(steps)
    @steps = steps
    @position = 0
    @buffer_size = 1
    @sequence = []
  end

  def exec
    50000000.times { step }
    @sequence.last
  end

  def step
    @position = (((@steps % @buffer_size) + @position) % @buffer_size) + 1
    if @position == 1
      @sequence << @buffer_size
      puts "#{@buffer_size} - #{@sequence.inspect}"
    end
    @buffer_size += 1
  end
end

puts Spinlock.new(335).exec
