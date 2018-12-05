class Captcha
  def initialize(input)
    @input = input
  end

  def input_chars
    @input.split('')
  end

  def part_1
    result = 0

    input_chars.each_with_index do |digit, i|
      if digit == next_digit(i)
        result += digit.to_i
      end
    end

    result
  end

  def next_digit(i)
    str = "#{@input}#{@input[0]}"
    str[i+1]
  end

  def part_2
    result = 0

    input_chars.each_with_index do |digit, i|
      if digit == oppposite_digit(i)
        result += digit.to_i
      end
    end

    result
  end

  def oppposite_digit(i)
    str = @input + @input
    pos = @input.length / 2
    str[i+pos]
  end
end
