require 'set'

input = DATA.each_line.map do |ln| 
  /Step (?<input>\w) must be finished before step (?<output>\w) can begin./ =~ ln  
  [input.to_sym, output.to_sym]
end

def build_graph(input)
  input.reduce({}) do |memo, (inp, outp)|
    memo[inp] ||= { outputs: [], inputs: [] }
    memo[inp][:outputs] << outp
    memo[outp] ||= { outputs: [], inputs: [] }
    memo[outp][:inputs] << inp
    memo
  end
end

graph = build_graph(input)
result = []

while(graph.size > 0)
  options = []
  graph.each { |node, io| options << node if io[:inputs].empty? }
  step = options.sort.first
  graph.delete(step)
  graph.each { |node, io| io[:inputs].delete(step) }
  result << step
end

puts "Part 1: #{result.join}"

graph = build_graph(input)

result = []
clock = 0
idle_hands = 5
time_remaining = graph.keys.reduce({}) { |memo, key| memo[key] = key.to_s.ord - 4; memo }
in_progress = Set.new

while(graph.size > 0)
  options = []
  graph.each { |node, io| options << node if io[:inputs].empty? && !in_progress.include?(node) }
  options.sort!

  while(idle_hands > 0 && options.size > 0)
    in_progress.add options.shift
    idle_hands -= 1
  end

  in_progress.each do |node| 
    time_remaining[node] -= 1 
  end

  # puts "#{clock} - #{idle_hands} - #{in_progress.inspect} - #{time_remaining.inspect}"

  in_progress.each do |node| 
    if time_remaining[node] == 0
      in_progress.delete node
      time_remaining.delete node
      graph.delete(node)
      graph.values.each { |io| io[:inputs].delete(node) }
      idle_hands += 1
      result << node
    end
  end  

  clock += 1
end

puts "Part 2: #{clock}"

__END__
Step B must be finished before step G can begin.
Step G must be finished before step J can begin.
Step J must be finished before step F can begin.
Step U must be finished before step Z can begin.
Step C must be finished before step M can begin.
Step Y must be finished before step I can begin.
Step Q must be finished before step A can begin.
Step N must be finished before step L can begin.
Step O must be finished before step A can begin.
Step Z must be finished before step T can begin.
Step I must be finished before step H can begin.
Step L must be finished before step W can begin.
Step F must be finished before step W can begin.
Step T must be finished before step X can begin.
Step A must be finished before step X can begin.
Step K must be finished before step X can begin.
Step S must be finished before step P can begin.
Step M must be finished before step E can begin.
Step E must be finished before step W can begin.
Step D must be finished before step P can begin.
Step P must be finished before step W can begin.
Step X must be finished before step H can begin.
Step V must be finished before step W can begin.
Step R must be finished before step H can begin.
Step H must be finished before step W can begin.
Step N must be finished before step I can begin.
Step X must be finished before step R can begin.
Step D must be finished before step V can begin.
Step V must be finished before step R can begin.
Step F must be finished before step K can begin.
Step P must be finished before step R can begin.
Step P must be finished before step V can begin.
Step S must be finished before step X can begin.
Step I must be finished before step S can begin.
Step J must be finished before step N can begin.
Step T must be finished before step S can begin.
Step T must be finished before step R can begin.
Step K must be finished before step P can begin.
Step N must be finished before step R can begin.
Step G must be finished before step T can begin.
Step I must be finished before step V can begin.
Step G must be finished before step Q can begin.
Step D must be finished before step H can begin.
Step V must be finished before step H can begin.
Step T must be finished before step K can begin.
Step T must be finished before step W can begin.
Step E must be finished before step H can begin.
Step C must be finished before step R can begin.
Step L must be finished before step K can begin.
Step G must be finished before step Y can begin.
Step Y must be finished before step O can begin.
Step O must be finished before step E can begin.
Step U must be finished before step S can begin.
Step X must be finished before step W can begin.
Step C must be finished before step D can begin.
Step E must be finished before step P can begin.
Step B must be finished before step R can begin.
Step F must be finished before step R can begin.
Step A must be finished before step D can begin.
Step G must be finished before step M can begin.
Step B must be finished before step Q can begin.
Step Q must be finished before step V can begin.
Step B must be finished before step W can begin.
Step S must be finished before step H can begin.
Step P must be finished before step X can begin.
Step I must be finished before step M can begin.
Step A must be finished before step S can begin.
Step M must be finished before step X can begin.
Step L must be finished before step S can begin.
Step S must be finished before step W can begin.
Step L must be finished before step V can begin.
Step Z must be finished before step X can begin.
Step M must be finished before step R can begin.
Step T must be finished before step A can begin.
Step N must be finished before step V can begin.
Step M must be finished before step H can begin.
Step E must be finished before step D can begin.
Step F must be finished before step V can begin.
Step B must be finished before step O can begin.
Step G must be finished before step U can begin.
Step J must be finished before step C can begin.
Step G must be finished before step F can begin.
Step Y must be finished before step M can begin.
Step F must be finished before step D can begin.
Step M must be finished before step P can begin.
Step F must be finished before step T can begin.
Step G must be finished before step A can begin.
Step G must be finished before step Z can begin.
Step K must be finished before step V can begin.
Step J must be finished before step Z can begin.
Step O must be finished before step Z can begin.
Step B must be finished before step E can begin.
Step Z must be finished before step V can begin.
Step Q must be finished before step O can begin.
Step J must be finished before step D can begin.
Step Y must be finished before step E can begin.
Step D must be finished before step R can begin.
Step I must be finished before step F can begin.
Step M must be finished before step V can begin.
Step I must be finished before step D can begin.
Step O must be finished before step P can begin.