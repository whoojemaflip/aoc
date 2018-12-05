class Checksum 
  def self.part_1(input)
    input.split("\n").reduce(0) do |memo, row|
      a = row.split(%r{\D}).delete_if(&:empty?).map(&:to_i).sort
      memo + (a.max - a.min)
    end
  end

  def self.part_2(input)
    input.split("\n").reduce(0) do |memo, row|
      a = row
        .split(%r{\D})
        .delete_if(&:empty?)
        .map(&:to_i)
        .permutation(2)
        .to_a
        .select { |arr| arr[0] % arr[1] == 0 }
        .flatten
      memo + (a.max / a.min)
    end
  end
end
