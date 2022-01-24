class Participant
  attr_accessor :hand, :name

  def initialize(name)
    @hand = []
    @name = name
  end

  def total(show: true)
    return 'unknown' unless show
    total = []
    hand.each do |card|
      total << card.to_points
    end
    calculate_ace(total) if total.include?('Ace')
    total.sum
  end

  def calculate_ace(points)
    pre_total = points.select { |el| el.is_a? Integer }.sum
    points[points.index('Ace')] = if (pre_total + 11) <= Game::LIMIT
                                    11
                                  else
                                    1
                                  end
  end

  def busted?
    total > Game::LIMIT
  end

  def show_cards
    hand.each { |card| puts card }
    puts ''
  end

  def self.tie
    "Wow, you got the same amount of points. Guess it's a tie!"
  end

  def won(other_participant)
    difference = total - other_participant.total
    "#{difference} more point#{difference > 1 ? 's' : ''}"
  end
end

class Player < Participant
  def initialize(name='You')
    super(name)
  end

  def show_cards
    puts "Your cards:"
    super
  end

  def display_busted
    puts ''
    puts "Oh no, you got more than #{Game::LIMIT} points. You lose :("
    puts ''
  end

  def won(other)
    puts "You got #{super}."
    puts "You won!"
  end
end

class Dealer < Participant
  def initialize
    names = ['Pro', 'Meta', 'Proxy', 'POkkkER']
    super(names.sample)
  end

  def show_cards
    puts "#{name}'s cards:"
    super
  end

  def display_busted
    puts "#{name} busted. You win!"
  end

  def won(other)
    puts "#{name} got #{super} than you."
    puts "You lost."
  end
end

class Deck
  attr_reader :deck

  SUITS = %w(Hearts Spades Diamonds Clubs)
  CARDS = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)

  def initialize
    @deck = []
    SUITS.each do |suit|
      CARDS.each { |value| @deck << Card.new(suit, value) }
    end
    @deck = @deck.shuffle
  end

  def deal
    deck.pop
  end
end

class Card
  attr_reader :card, :value

  def initialize(suit, value)
    @value = value
    @card = [@value, suit]
  end

  def to_s
    "#{value} of #{card.last}"
  end

  def to_points
    if value.to_i > 0
      value.to_i
    elsif value == 'Ace'
      'Ace'
    else
      10
    end
  end
end

class Game
  attr_accessor :player, :dealer
  attr_reader :deck

  LIMIT = 21
  HIT_LIMIT = 21 - 4

  def initialize(name=nil)
    @player = Player.new(name)
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start
    system 'clear'
    display_welcome
    pause

    main_play

    display_goodbye
  end

  def main_play
    loop do
      system 'clear'
      deal_cards
      show_total

      player_turn

      if player.busted?
        player.display_busted
      else
        dealer_turn
        show_result
      end

      again = play_again?
      break unless again
      initialize(player.name)
    end
  end

  def display_welcome
    puts "Welcome to the game of Twenty-One!"
    puts ''
    puts "What's your name?"
    player.name = gets.chomp.capitalize
    puts ''
  end

  def pause
    puts 'Press any key to continue:'
    gets.chomp
  end

  def deal_cards
    2.times do |_|
      player.hand << deck.deal
      dealer.hand << deck.deal
    end
  end

  def show_total(show_dealer=false)
    puts "#{dealer.name}: #{dealer.total(show: show_dealer)}"
    puts "#{player.name}: #{player.total}"
    puts ''
    player.show_cards
    dealer.show_cards if show_dealer
  end

  def player_turn
    puts ''
    puts "Time to decide. Do you want to hit or stay?"

    loop do
      answer = hit_or_stay
      break if answer == 'stay'
      hit(player)

      break if player.busted?

      puts ''
      pause
      system 'clear'
      show_total
      puts ''
      puts "Hit or Stay?"
    end

    pause
  end

  def hit_or_stay
    answer = nil
    loop do
      answer = gets.chomp
      break if ['hit', 'stay'].include? answer
      puts 'Please choose hit or stay:'
    end
    answer
  end

  def hit(participant)
    new_card = deck.deal
    participant.hand << new_card
    puts "You got #{new_card}" if participant.is_a? Player
  end

  def dealer_turn
    until dealer.total >= HIT_LIMIT
      hit(dealer)
    end
    show_total(true)
  end

  def show_result
    dealer.display_busted if dealer.busted?
    case dealer.total <=> player.total
    when 1 then dealer.won(player)
    when -1 then player.won(dealer)
    when 0 then Participant.tie
    end
  end

  def play_again?
    answer = nil
    puts ''
    puts "Do you want to play again? (y/n)"

    loop do
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry the answer is not valid."
    end

    answer == 'y'
  end

  def display_goodbye
    puts ''
    puts "Thanks for playing Twenty-One. Goodbye."
  end
end

Game.new.start
