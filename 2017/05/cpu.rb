require 'pry'

class Cpu 
  attr_reader :instructions

  def initialize(instructions, pos)
    @instructions = instructions
    @pos = pos
    @counter = 0
  end

  def run_1
    while !completed? do
      step_1
      @counter += 1
    end
    @counter
  end

  def step_1
    previous_instruction_pointer = @pos
    @pos += @instructions[@pos]
    @instructions[previous_instruction_pointer] += 1
  end

  def run_2
    while !completed? do
      step_2
      @counter += 1
    end
    @counter
  end

  def step_2
    previous_instruction_pointer = @pos
    @pos += @instructions[@pos]
    
    if @instructions[previous_instruction_pointer] >= 3
      @instructions[previous_instruction_pointer] -= 1
    else
      @instructions[previous_instruction_pointer] += 1
    end
  end

  def offset
    if completed? 
      -1
    else
      @pos
    end
  end

  def completed?
    @pos < 0 || @pos >= instructions.size
  end
end
