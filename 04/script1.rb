lines = File.readlines("input").map(&:strip)

class Card
  attr_reader :id
  attr_reader :winning_numbers
  attr_reader :scratched_numbers

  def initialize(line)
    card_part, numbers_part = line.split(":")
    
    @id = card_part.split(" ").last.to_i

    winning_numbers_part, scratched_numbers_part = numbers_part.split("|")
    @winning_numbers = winning_numbers_part.strip.split(" ").map(&:to_i)
    @scratched_numbers = scratched_numbers_part.strip.split(" ").map(&:to_i)
  end

  def score
    match_count = @winning_numbers.intersection(@scratched_numbers).count

    match_count == 0 ? 0 : 2.pow(match_count - 1)
  end
end

cards = lines.map {|l| Card.new(l)}

puts cards.map(&:score).sum
