lines = File.readlines("input")


class Hand
  include Comparable

  CARD_TO_VALUE = {
    "A" => 14,
    "K" => 13,
    "Q" => 12,
    "J" => 1,
    "T" => 10,
    "9" => 9,
    "8" => 8,
    "7" => 7,
    "6" => 6,
    "5" => 5,
    "4" => 4,
    "3" => 3,
    "2" => 2,
  }

  attr_reader :hand
  attr_reader :bid
  attr_reader :type
  attr_reader :values

  def initialize(hand, bid)
    @hand = hand.split("")
    @bid = bid.to_i

    @distribution = {}
    @hand.each do |card|
      @distribution[card] ||= 0
      @distribution[card] += 1
    end
    @joker_count = @distribution["J"] || 0

    @distribution_without_joker = @distribution.dup
    @distribution_without_joker.delete("J")


    if @distribution_without_joker.empty?
      @type = 7
    else 
      highest_card = @distribution_without_joker.to_a.sort_by {|card, count| count}.last.first
      @distribution_without_joker[highest_card] += @joker_count

      @type = 
        if @distribution_without_joker.keys.count == 1
          # Five of a kind
          7
        elsif @distribution_without_joker.keys.count == 2
          if @distribution_without_joker.values.any?{|c| c== 4}
            # Four of a kind
            6
          else 
            # Full House
            5
          end
        elsif @distribution_without_joker.keys.count == 3
          if @distribution_without_joker.values.any?{|c| c == 3}
            # Three of a kind
            4
          else 
            # Two pair
            3
          end
        elsif @distribution_without_joker.keys.count == 4
          # One pair
          2
        else
          1
        end
    end

    @values = @hand.map {|c| CARD_TO_VALUE[c]}
  end

  def <=>(other)
    if self.type == other.type
      self.values  <=> other.values
    else 
      self.type <=> other.type
    end
  end
end

hands = lines.map do |l|
  hand, bid = l.split(" ")
  Hand.new(hand, bid)
end

sorted_hands = hands.sort

puts sorted_hands.each_with_index.map {|hand, i| hand.bid * (i+1)}.sum
