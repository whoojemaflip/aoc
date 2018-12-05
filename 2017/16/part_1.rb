def assert_equal(a, b)
  raise unless a==b
end

def spin(str, x)
  str.slice!(x * -1, x) + str
end

assert_equal spin('abcde', 3), 'cdeab'
assert_equal spin('abcde', 1), 'eabcd'

def exchange(str, a, b)
  str_a = str[a]
  str_b = str[b]
  str.tr!(str_a, '$')
  str.tr!(str_b, str_a)
  str.tr!('$', str_b)
  str
end

assert_equal exchange('abcde', 3, 4), 'abced'

def partner(str, str_a, str_b)
  str.tr!(str_a, '$')
  str.tr!(str_b, str_a)
  str.tr!('$', str_b)
  str
end

assert_equal partner('abcde', 'e', 'b'), 'aecdb'

input = File.read('input.txt').split(',')
programs = 'abcdefghijklmnop'

input.each do |dance|
  case dance
  when /^s(\d*)$/
    programs = spin(programs, $1.to_i)
  when /^x(\d*)\/(\d*)$/
    programs = exchange(programs, $1.to_i, $2.to_i)
  when /^p(\w)\/(\w)$/
    programs = partner(programs, $1, $2)
  end
end

puts programs
