class Passphrase
  def self.part_1_valid?(phrase)
    words = phrase.split(%r{\W})
    words.length == words.uniq.length
  end

  def self.part_2_valid?(phrase)
    words = phrase.split(%r{\W}).map { |word| word.chars.sort.join }
    words.length == words.uniq.length
  end
end
