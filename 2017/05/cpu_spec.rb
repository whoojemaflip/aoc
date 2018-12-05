require_relative 'cpu'
require 'rspec'

RSpec.describe Cpu do
  describe 'Part 1' do
    example '1' do
      subject = Cpu.new([0, 3, 0, 1, -3], 0)
      result = subject.run_1
      expect(result).to be 5
    end

    describe 'step' do
      example '1' do
        subject = Cpu.new([0, 3, 0, 1, -3], 0)
        subject.step_1
        expect(subject.instructions).to eql [1, 3, 0, 1, -3]
        expect(subject.offset).to eql 0
        expect(subject.completed?).to be false
      end

      example '2' do
        subject = Cpu.new([1, 3, 0, 1, -3], 0)
        subject.step_1
        expect(subject.instructions).to eql [2, 3, 0, 1, -3]
        expect(subject.offset).to eql 1
        expect(subject.completed?).to be false
      end

      example '3' do
        subject = Cpu.new([2, 3, 0, 1, -3], 1)
        subject.step_1
        expect(subject.instructions).to eql [2, 4, 0, 1, -3]
        expect(subject.offset).to eql 4
        expect(subject.completed?).to be false
      end

      example '4' do
        subject = Cpu.new([2, 4, 0, 1, -3], 4)
        subject.step_1
        expect(subject.instructions).to eql [2, 4, 0, 1, -2]
        expect(subject.offset).to eql 1
        expect(subject.completed?).to be false
      end

      example '5' do
        subject = Cpu.new([2, 4, 0, 1, -2], 1)
        subject.step_1
        expect(subject.instructions).to eql [2, 5, 0, 1, -2]
        expect(subject.offset).to eql -1
        expect(subject.completed?).to be true
      end
    end
  end

  describe 'Part 1' do
    example '1' do
      subject = Cpu.new([0, 3, 0, 1, -3], 0)
      result = subject.run_2
      expect(result).to be 10
    end
  end
end
