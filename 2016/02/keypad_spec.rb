require_relative 'keypad'

describe Keypad do
  let(:subject) { Keypad.new }
  let(:result) { subject.num }

  context "test 1" do
    let(:data) { "ULL\nRRDDD\nLURDL\nUUUUD" }
    let(:result) { subject.door_code(data) }

    it "should be right" do
      expect(result.join).to eql '1985'
    end
  end

  describe "valid_option?" do
    it "tests for x < 0" do
      expect(subject.valid_option?(-1, 0)).to be false
    end

    it "tests for y < 0" do
      expect(subject.valid_option?(0, -1)).to be false
    end

    it "tests for x > 2" do
      expect(subject.valid_option?(3, 0)).to be false
    end

    it "tests for y > 2" do
      expect(subject.valid_option?(0, 3)).to be false
    end
  end

  describe "#num" do
    it "initializes to 5" do
      expect(result).to eql 5
    end
  end

  describe "#move" do
    it "U moves one up" do
      subject.move('U')
      expect(result).to eql 2
    end

    it "U twice still equals 2" do
      subject.move('U')
      subject.move('U')
      expect(result).to eql 2
    end

    it "D once equals 8" do
      subject.move('D')
      expect(result).to eql 8
    end

    it "D twice still equals 8" do
      subject.move('D')
      subject.move('D')
      expect(result).to eql 8
    end

    it "L once equals 4" do
      subject.move('L')
      expect(result).to eql 4
    end

    it "L twice still equals 4" do
      subject.move('L')
      subject.move('L')
      expect(result).to eql 4
    end

    it "R once equals 6" do
      subject.move('R')
      expect(result).to eql 6
    end

    it "R twice still equals 6" do
      subject.move('R')
      subject.move('R')
      expect(result).to eql 6
    end
  end

  # data = "ULL\nRRDDD\nLURDL\nUUUUD"
  # result = calculate_door_code(data)
  # expect(result).to eql 1985
end
