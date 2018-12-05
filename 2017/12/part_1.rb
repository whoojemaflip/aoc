def assert_equal(a, b)
  raise unless a == b
end

data = File.read('input.txt').strip

test_data = <<EOF
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
EOF

require 'pry'

def parse(str)
  regex = %r{^(\d*) <-> (.*)$}
  str.split("\n").map do |line|
    matches = regex.match line
    {
      from: matches[1].to_i,
      to: matches[2].split(', ').map(&:to_i)
    }
  end
end

def program_group_count(str)
  parsed_data = parse(str).reduce({}) { |acc, l| acc.tap { acc[l[:from]] = l[:to] } }
  follow_up = [0]
  investigated = []

  until follow_up.empty?
    current = follow_up.shift
    next_data = parsed_data[current]

    follow_up.concat next_data.delete_if { |i| investigated.include? i }
    investigated << current
  end

  investigated.uniq.size
end

assert_equal program_group_count(test_data), 6

puts program_group_count(data)
