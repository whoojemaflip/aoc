require_relative 'keypad_two'

describe KeypadTwo do
  let(:subject) { KeypadTwo.new }
  let(:result) { subject.num }

  context "test 2" do
    let(:data) { "ULL\nRRDDD\nLURDL\nUUUUD" }
    let(:result) { subject.door_code(data) }

    it "should be right" do
      expect(result.join).to eql '5DB3'
    end
  end

  describe "valud_option?" do
    it "tests for x < 0" do
      expect(subject.valid_option?(-1, 0)).to be false
    end

    it "tests for y < 0" do
      expect(subject.valid_option?(0, -1)).to be false
    end

    it "tests for x > 4" do
      expect(subject.valid_option?(5, 0)).to be false
    end

    it "tests for y > 4" do
      expect(subject.valid_option?(0, 5)).to be false
    end

    it "tests for blank space" do
      expect(subject.valid_option?(0, 0)).to be false
    end
  end
end
