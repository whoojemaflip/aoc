require 'pry'

class GarbageParser
  attr_reader :score, :garbage_chars

  def initialize(str)
    @score = 0
    @garbage_chars = 0
    
    @group_nesting_depth = 0
    @in_garbage = false
    @ignore_next_char = false

    parse(str)
  end

  private

  def parse(str)
    str.each_char do |char|
      if @ignore_next_char
        @ignore_next_char = false
      elsif char == '!'
        @ignore_next_char = true
      elsif @in_garbage
        if char == '>'
          @in_garbage = false 
        else
          @garbage_chars += 1
        end
      elsif char == '<'
        @in_garbage = true
      elsif char == '{'
        @group_nesting_depth += 1
      elsif char == '}'
        @score += @group_nesting_depth
        @group_nesting_depth -= 1
      end
    end
  end
end
