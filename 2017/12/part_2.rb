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

def parse(str)
  regex = %r{^(\d*) <-> (.*)$}
  strs = str.split("\n").map do |line|
    matches = regex.match line
    {
      from: matches[1].to_i,
      to: matches[2].split(', ').map(&:to_i)
    }
  end

  strs.reduce({}) { |acc, l| acc.tap { acc[l[:from]] = l[:to] } }
end

def explore_program_group(start, parsed_data)
  follow_up = [start]
  investigated = []

  until follow_up.empty?
    current = follow_up.shift
    next_data = parsed_data[current] || []

    follow_up.concat next_data.delete_if { |i| investigated.include? i }
    investigated << current
  end

  investigated.uniq
end

def count_programs(parsed_data)
  count = 0

  until parsed_data.empty?
    result = explore_program_group(parsed_data.first[0], parsed_data)

    result.each do |i|
      parsed_data.delete(i)
    end
    count += 1
  end  

  count
end

assert_equal count_programs(parse test_data), 2

puts count_programs(parse data)
