class String
  def integer?
    true if Integer(self) rescue false
  end
end

class Cpu
  attr_accessor :pc, :a, :b, :c, :d

  def initialize
    @pc = 0
    @a = 0
    @b = 0
    @c = 1
    @d = 0
  end

  def load(file)
    program_lines = File.open(file, 'rb').read.split("\n")
    @prog = program_lines.map { |line| parse_line(line) }
    @high_mem = @prog.size
  end

  def valid_instruction
    @prog[@pc][:ins] != nil
  end

  def run
    while((@pc < @high_mem) && valid_instruction)
      put_state
      exec
      increment_program_counter
      #binding.pry if @pc % 5 == 0
    end
    puts "Program complete."
  end

  def exec
    cmd = @prog[@pc]

    #puts cmd

    begin
      if cmd[:arg2]
        send(cmd[:ins], cmd[:arg1], cmd[:arg2])
      else
        send(cmd[:ins], cmd[:arg1])
      end
    rescue Exception => e
      puts cmd
      puts e.message
      puts e.backtrace
      exit(1)
    end
  end

  def parse_line(line)
    regex = /\A(?<ins>[a-z]{3}) (?<arg1>[\-a-z0-9]+) ?(?<arg2>[\-a-z0-9]+)?\Z/
    result = regex.match(line)

    instruction = result[:ins].to_sym
    arg1 = result[:arg1]
    arg2 = result[:arg2]

    {ins: instruction, arg1: arg1, arg2: arg2}
  end

  def increment_program_counter
    @pc = pc + 1
  end

  def put_state
    puts "#{pc}\t#{a},\t#{b}\t#{c}\t#{d}"
  end

  def cpy(value_or_register, register)
    value = eval_to_value(value_or_register)
    set_reg(register, value)
  end

  def jnz(value_or_register, jump)
    value = eval_to_value(value_or_register)
    if value != 0
      @pc = pc + Integer(jump) - 1
    end
  end

  def inc(register)
    value = get_reg(register)
    set_reg(register, value + 1)
  end

  def dec(register)
    value = get_reg(register)
    set_reg(register, value - 1)
  end

  private

  def eval_to_value(value_or_register)
    if value_or_register.integer?
      Integer(value_or_register)
    else
      value = get_reg(value_or_register)
    end
  end

  def get_reg(register)
    send("#{register}")
  end

  def set_reg(register, value)
    send("#{register}=".to_sym, value)
  end
end
