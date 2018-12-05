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

class Msg
  attr_reader :value

  def initialize(key, value = nil)
    @key = key
    @value = value
  end

  def noop?
    @key == :noop
  end

  def send?
    @key == :snd
  end

  def rcv_err?
    @key == :rcv_err
  end

  def terminated?
    @key == :terminated
  end
end

class Program
  def initialize(id, asm)
    @registers = {'p' => id}
    @asm = asm
    @pc = 0
    @queue = []
    @terminated = false
  end

  def enqueue(val)
    @queue << val
  end

  def program_terminated?
    @terminated ||= (@pc >= @asm.length)
  end

  def run
    if program_terminated?
      return Msg.new(:terminated)
    end

    line = @asm[@pc]

    ins = line[:ins]
    x = decode(line[:x])
    y = decode(line[:y])

  #  puts "#{pc} #{ins} #{line[:x]} #{y} #{registers.inspect}"

    case ins
    when 'snd'
      inc_pc
      Msg.new(:snd, x)
    when 'set'
      @registers[line[:x]] = y
      inc_pc
      Msg.new(:noop)
    when 'add'
      @registers[line[:x]] = x + y
      inc_pc
      Msg.new(:noop)
    when 'mul'
      @registers[line[:x]] = x * y
      inc_pc
      Msg.new(:noop)
    when 'mod'
      @registers[line[:x]] = x % y
      inc_pc
      Msg.new(:noop)
    when 'rcv'
      unless @queue.empty?
        inc_pc
        @registers[line[:x]] = @queue.shift
        Msg.new(:noop)
      else
        Msg.new(:rcv_err)
      end
    when 'jgz'
      if x > 0
        inc_pc(y)
      else
        inc_pc
      end
      Msg.new(:noop)
    end
  end

  def inc_pc(n = 1)
    @pc += n
  end

  def decode(thing)
    if thing.to_i.to_s == thing
      thing.to_i
    else
      @registers.fetch(thing, 0)
    end
  end
end

input = parse File.read('input.txt')

test_input = <<EOF
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
EOF

#input = parse test_input

a = Program.new(0, input)
b = Program.new(1, input)

counter = 0

while true
  msg_a = a.run
  puts msg_a.inspect
  if msg_a.send?
    b.enqueue msg_a.value
  end

  msg_b = b.run
  puts msg_b.inspect

  if msg_b.send?
    a.enqueue msg_b.value
    counter += 1
  end

  if msg_a.terminated? && msg_b.terminated?
    break
  elsif msg_a.rcv_err? && msg_b.rcv_err?
    break
  end
end

puts counter





