data = <<EOD
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
EOD

data = File.read("input.txt")

def parse(line)
  regex = %r{^(\w*) (inc|dec) (-?\d*) if (\w*) ([<>!=]*) (-?\d*)$}
  matches = regex.match line

  {
    register_to_modify: matches[1],
    inc_or_dec: matches[2],
    amount_to_inc_or_dec: matches[3].to_i,
    conditional_target: matches[4],
    condition: matches[5],
    conditional_amount: matches[6].to_i
  }
end

instructions = data.strip.split("\n").map { |line| parse(line) }

@registers = {}

def register(reg)
  @registers[reg] ||= 0
end

def modify_register(register_to_modify:, inc_or_dec:, amount_to_inc_or_dec:, **rest)
  if inc_or_dec == 'inc'
    @registers[register_to_modify] = register(register_to_modify) + amount_to_inc_or_dec
  else
    @registers[register_to_modify] = register(register_to_modify) - amount_to_inc_or_dec
  end
end

def conditional(conditional_target:, condition:, conditional_amount:, **rest)
  eval "#{register(conditional_target)} #{condition} #{conditional_amount}"
end

max_values = []

instructions.each do |ins|
  modify_register(ins) if conditional(ins)
  max_values << @registers.values.max
end

puts "part 1: #{@registers.values.max}"
puts "part 2: #{max_values.max}"
