def assert_equal(a, b)
  raise unless a==b
end

class Programs
  def initialize(str)
    @programs = str.chars
  end

  def to_s
    @programs.join
  end

  def spin(x)
    @programs.rotate!(x * -1)
    self
  end

  def exchange(a, b)
    _a = @programs[a]
    @programs[a] = @programs[b]
    @programs[b] = _a
    self
  end

  def partner(str_a, str_b)
    _a = @programs.index(str_a)
    _b = @programs.index(str_b)
    @programs[_a] = str_b
    @programs[_b] = str_a
    self
  end
end

assert_equal Programs.new('abcde').spin(3).to_s, 'cdeab'
assert_equal Programs.new('abcde').spin(1).to_s, 'eabcd'
assert_equal Programs.new('abcde').exchange(3, 4).to_s, 'abced'
assert_equal Programs.new('abcde').partner('e', 'b').to_s, 'aecdb'

input = File.read('input.txt').split(',')
programs = Programs.new('abcdefghijklmnop')

def dance(programs, dance)
  case dance
  when /^s(\d*)$/
    programs.spin($1.to_i)
  when /^x(\d*)\/(\d*)$/
    programs.exchange($1.to_i, $2.to_i)
  when /^p(\w)\/(\w)$/
    programs.partner($1, $2)
  end
end

count = 0

while true do 
  input.each do |dance_move|
    dance(programs, dance_move)
  end

  count += 1
  break if programs.to_s == 'abcdefghijklmnop'
end

cycles = 1000000000 % count

cycles.times do 
  input.each do |dance_move|
    dance(programs, dance_move)
  end
end

puts programs.to_s
