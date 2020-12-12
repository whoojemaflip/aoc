require 'pry'

def assert(fact)
  fail unless fact
end

def parse(input)
  input.strip.split("\n").map(&:to_i)
end

class Joltages
  def initialize(jolts)
    @jolts = [0] + jolts.sort + [jolts.max + 3]
  end

  def differences
    differences = @jolts.each_with_index.reduce({}) do |acc, (jolt, i)|
      unless i.zero?
        difference = jolt - @jolts[i-1]

        acc[difference] ||= 0
        acc[difference] += 1
      end
      acc
    end

    differences[1] * differences[3]
  end

  def arrangements
    permutations = {
      2 => 2,
      3 => 4,
      4 => 7
    }

    @jolts
      .each_cons(2)
      .map { |previous, adapter| adapter - previous }
      .chunk { |diff| diff }
      .map { |diff, seq| [diff, seq.length] }
      .select { |(diff, count)| diff == 1 && count > 1 }
      .map { |(_, seq)| seq }
      .map { |seq| permutations[seq] }
      .reduce(&:*)
  end
end

input = parse(DATA.read)

test_input = parse(%Q{
16
10
15
5
1
11
7
19
6
12
4
})

test_input_2 = parse(%Q{
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
})


assert Joltages.new(test_input).differences == 35
assert Joltages.new(test_input_2).differences == 220

puts "Part 1: " + Joltages.new(input).differences.to_s

assert Joltages.new(test_input).arrangements == 8
assert Joltages.new(test_input_2).arrangements == 19208

puts "Part 2: " + Joltages.new(input).arrangements.to_s

__END__
59
134
159
125
95
92
169
43
154
46
110
79
117
151
141
56
87
10
65
170
89
32
40
118
36
94
124
173
164
166
113
67
76
102
107
52
144
119
2
72
86
73
66
13
15
38
47
109
103
128
165
148
116
146
18
135
68
83
133
171
145
48
31
106
161
6
21
22
77
172
28
78
96
55
132
39
100
108
33
23
54
157
80
153
9
62
26
147
1
27
131
88
138
93
14
123
122
158
152
71
49
101
37
99
160
53
3
