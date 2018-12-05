require_relative 'captcha'
require 'rspec'

RSpec.describe Captcha do
  example 'Part 1' do
    cases = {
      '1122' => 3,
      '1111' => 4,
      '1234' => 0,
      '91212129' => 9
    }

    cases.each do |input, expected_result|
      expect(Captcha.new(input).part_1).to eql expected_result
    end
  end

  example 'Part 2' do
    cases = {
      '1212' => 6,
      '1221' => 0,
      '123425' => 4,
      '123123' => 12,
      '12131415' => 4
    }

    cases.each do |input, expected_result|
      expect(Captcha.new(input).part_2).to eql expected_result
    end
  end
end
