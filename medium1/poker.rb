class PokerHand
  attr_reader :hand

  def initialize(deck)
    @hand = []
    5.times { |_| @hand << deck.draw }
    @hand = hand.sort
  end

  def print
    hand.each { |card| puts card }
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    req = [10, 'Jack', 'Queen', 'King', 'Ace']
    flush? && hand.map(&:rank) == req
  end

  def straight_flush?
    flush? && straight?
  end

  def find_kinds
    current = []

    ranks_only = hand.map(&:rank)

    ranks_only.uniq.each do |rank|
      current << ranks_only.count(rank)
    end

    current.sort
  end

  def four_of_a_kind?
    req = [1, 4]
    find_kinds == req
  end

  def full_house?
    req = [2, 3]
    find_kinds == req
  end

  def flush?
    hand.map(&:suit).uniq.count == 1
  end

  def straight?
    5.times do |counter|
      compare = (hand[0].comparable_value + counter == hand[counter].comparable_value)
      return false unless compare
    end
  end

  def three_of_a_kind?
    req = 3
    find_kinds.reverse.first == req
  end

  def two_pair?
    req = [1, 2, 2]
    find_kinds == req
  end

  def pair?
    req = 2
    find_kinds.reverse.first == req
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_accessor :deck

  def initialize
    @deck = []

    RANKS.each do |rank|
      SUITS.each { |suit| @deck << Card.new(rank, suit) }
    end

    @deck.shuffle!
  end

  def draw
    initialize if deck.empty?
    deck.pop
  end
end

class Card < Deck
  include Comparable

  attr_reader :rank, :suit, :comparable_value

  def initialize(value, suit)
    @rank = value
    @comparable_value = to_comparable(value)
    @suit = suit
  end

  def <=>(other_obj)
    self.comparable_value <=> other_obj.comparable_value
  end

  def to_comparable(value)
    case value
    when "Ace" then 14
    when "King" then 13
    when "Queen" then 12
    when "Jack" then 11
    else value
    end
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'