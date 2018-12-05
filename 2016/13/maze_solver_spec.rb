require_relative "maze_solver"
require_relative "maze_builder"
require 'pry'

RSpec.describe MazeSolver do
  let(:maze) { [[".", ".", "."], [".", ".", "."]] }
  let(:subject) { described_class.new(maze, x, y) }
  let(:x) { 1 }
  let(:y) { 1 }

  describe "#valid_moves" do
    let(:result) { subject.valid_moves(maze, x, y) }

    context "against 2 edges" do
      let(:x) { 0 }

      it "returns two options" do
        expect(result.size).to eql 2
      end
    end
  end

  describe "#immediately_solveable?" do
    let(:result) { subject.immediately_solveable?(maze, x, y) }
    let(:x) { 6 }
    let(:y) { 4 }
    let(:maze) { MazeBuilder.new.plot }

    it "should at least get this right" do
      expect(result).to be true
    end
  end
end
