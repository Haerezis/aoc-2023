lines = File.readlines("input").map(&:strip)

class Card
  attr_reader :id
  attr_reader :winning_numbers
  attr_reader :scratched_numbers
  attr_reader :count

  def initialize(line)
    card_part, numbers_part = line.split(":")
    
    @id = card_part.split(" ").last.to_i

    winning_numbers_part, scratched_numbers_part = numbers_part.split("|")
    @winning_numbers = winning_numbers_part.strip.split(" ").map(&:to_i)
    @scratched_numbers = scratched_numbers_part.strip.split(" ").map(&:to_i)

    @count = 1
  end

  def matching_count
    match_count = @winning_numbers.intersection(@scratched_numbers).count
  end

  def inc_count(v)
    @count += v
  end
end

cards = lines.map {|l| Card.new(l)}

cards.each_with_index do |card, i|
  matching_count = card.matching_count
  (1..matching_count).each do |j|
    cards[i + j]&.inc_count(card.count)
  end
end

puts cards.map(&:count).sum
