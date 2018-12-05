require 'pry'
require 'pp'

data = <<EOF
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
EOF

data = File.read('input.txt').strip
line_regex = %r(^([\w]+) \((\d*)\)(.*)$)

programs = {}

data.split("\n").map do |line|
  matchdata = line_regex.match line
  title = matchdata[1]
  weight = matchdata[2]
  sub_programs = []

  unless matchdata[3].empty?
    sub_line = matchdata[3]
    sub_line.gsub!(' -> ', '')
    sub_programs = sub_line.split(', ')
  end

  programs[title] = {
    weight: weight,
    sub_programs: sub_programs
  }
end

programs.each do |title, details|
  unless details[:sub_programs].empty?
    details[:sub_programs].each do |sp|
      programs[sp][:parent] = title
    end
  end
end

programs.each do |title, details|
  unless details.has_key? :parent
    puts title
  end
end

