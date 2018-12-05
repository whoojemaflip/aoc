require 'pry'

class Msg
  attr_reader :value

  def initialize(key, value = nil)
    @key = key
    @value = value
  end

  def noop?
    @key == :noop
  end

  def mul?
    @key == :mul
  end

  def terminated?
    @key == :terminated
  end
end

class Program
  def initialize(asm)
    @asm = parse asm
    @pc = 25
    @terminated = false
    @registers = { 
      'a' => 1, 
      'b' => 108100, 
      'c' => 125100, 
      'd' => 108100, 
      'e' => 108100, 
      'f' => 0, 
      'g' => 0, 
      'h' => 0 
    }
  end

  def terminated?
    @terminated ||= (@pc >= @asm.length)
  end

  def registers
    @registers
  end

  def run
    if terminated?
      return Msg.new(:terminated)
    end

    line = @asm[@pc]

    ins = line[:ins]
    x = decode(line[:x])
    y = decode(line[:y])

    if @pc == 23
      puts "#{@pc} - #{line[:ins]} #{line[:x]}(#{x}) #{line[:y]}(#{y}) #{@registers.inspect}"
    end

    case ins
    when 'set'
      @registers[line[:x]] = y
      inc_pc
    when 'sub'
      @registers[line[:x]] = x - y
      inc_pc
    when 'mul'
      @registers[line[:x]] = x * y
      inc_pc
      return Msg.new(:mul)
    when 'jnz'
      if x != 0
        inc_pc(y)
      else
        inc_pc
      end
    end

    Msg.new(:noop)
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

  def parse(str)
    str.split("\n").map do |line|
      regex = %r{^(\w\w\w) ([-\w\d]+) ?([-\w\d]+)?}
      matches = regex.match line

      {
        ins: matches[1],
        x: matches[2]
      }.tap do |r|
        r[:y] = matches[3] if matches[3]
      end
    end
  end
end

program = Program.new File.read('input.txt')
counter = 0

until program.terminated?
  msg = program.run

  if msg.mul?
    counter += 1
  end
end

puts program.registers.inspect
puts counter





