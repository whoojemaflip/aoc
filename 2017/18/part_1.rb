require 'pry'

def parse(str)
  str.split("\n").map do |line|
    regex = %r{(\w\w\w) ([-\w\d]+) ?([-\w\d]+)?}
    matches = regex.match line

    {
      ins: matches[1],
      x: matches[2]
    }.tap do |r|
      r[:y] = matches[3] if matches[3]
    end
  end
end

def decode(registers, thing)
  if thing.to_i.to_s == thing
    thing.to_i
  else
    registers.fetch(thing, 0)
  end
end

def run(program)
  registers = {}
  sound = nil

  pc = 0

  while true
    line = program[pc]

    ins = line[:ins]
    x = decode(registers, line[:x])
    y = decode(registers, line[:y])

  #  puts "#{pc} #{ins} #{line[:x]} #{y} #{registers.inspect}"

    case ins
    when 'snd'
      sound = x
      pc += 1
    when 'set'
      registers[line[:x]] = y
      pc += 1
    when 'add'
      registers[line[:x]] = x + y
      pc += 1
    when 'mul'
      registers[line[:x]] = x * y
      pc += 1
    when 'mod'
      registers[line[:x]] = x % y
      pc += 1
    when 'rcv'
      if x != 0
        puts sound
        break
      end
      pc += 1
    when 'jgz'
      if x > 0
        pc += y 
      else
        pc += 1
      end
    end

  end
end

input = parse File.read('input.txt')

test_input = <<EOF
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
EOF

test_input = parse test_input

run(input)

