require 'pry'
require 'set'

def assert(fact)
  fail unless fact
end

def parse(input)
  input.split(',').map(&:to_i)
end

class MemoryGame
  def initialize(input, game_length)
    @input = input
    @game_length = game_length
  end

  def run
    first_round = @input
      .each_with_index
      .reduce({}) { |acc, (num, i)| acc[num] = i + 1; acc }

    current = 0

    (@input.length + 1..@game_length - 1).reduce(first_round) do |history, turn|
      history.tap do |h|
        _next = \
          if h[current]
            turn - h[current]
          else
            0
          end
        h[current] = turn
        current = _next
      end
    end

    current
  end
end

input = parse('19,20,14,0,9,1')

test_input = parse('0,3,6')

assert MemoryGame.new(test_input, 2020).run == 436
assert MemoryGame.new(test_input, 30000000).run == 175594

puts "Part 1: " + MemoryGame.new(input, 2020).run.to_s
puts "Part 2: " + MemoryGame.new(input, 30000000).run.to_s

__END__
