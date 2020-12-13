require 'pry'

def assert(fact)
  fail unless fact
end

def parse(input)
  input.strip.split("\n")
end

class Timetable
  def initialize(input)
    @estimate = input[0].to_i
    @bus_times = input[1].split(',').select { |b| b != 'x' }.map(&:to_i)
  end

  def result
    minimum_wait.reduce(&:*)
  end

  def minimum_wait
    @bus_times.reduce([@bus_times.max]*2) do |(min_wait, best_bus), bus_id|
      wait = bus_id - (@estimate % bus_id)
      wait < min_wait ? [wait, bus_id] : [min_wait, best_bus]
    end
  end
end

class Contest
  def initialize(buses)
    @bus_times = buses
      .split(',')
      .each_with_index
      .select { |b, _i| b != 'x' }
      .map { |(bus_id, i)| [i, bus_id.to_i] }
      .map { |(rem, mod)| [mod - (rem % mod), mod] }
  end

  def next_intersection(start, multiplier, mod, remainder)
    (start..).step(multiplier).each { |i| return i if i % mod == remainder }
  end

  def lcm(i)
    @bus_times.take(i).map { |(_, mod)| mod }.reduce(&:*)
  end

  def result
    res = @bus_times.each_with_index.reduce(0) do |acc, ((rem, mod), i)|
      if i > 0
        next_intersection(acc, lcm(i), mod, rem)
      else
        acc
      end
    end
  end
end

input = parse(DATA.read)

test_input = parse(%Q{
939
7,13,x,x,59,x,31,19
})

assert Timetable.new(test_input).result == 295

assert Contest.new("7,13,x,x,59,x,31,19").result == 1068781
assert Contest.new("17,x,13,19").result == 3417
assert Contest.new("67,7,59,61").result == 754018
assert Contest.new("67,x,7,59,61").result == 779210
assert Contest.new("67,7,x,59,61").result == 1261476
assert Contest.new("1789,37,47,1889").result == 1202161486

puts "Part 1: " + Timetable.new(input).result.to_s
puts "Part 2: " + Contest.new(input[1]).result.to_s

__END__
1007268
17,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,937,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,13,x,x,x,x,23,x,x,x,x,x,29,x,397,x,x,x,x,x,37,x,x,x,x,x,x,x,x,x,x,x,x,19
