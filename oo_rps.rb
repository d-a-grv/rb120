# require 'pry'

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @version = nil
  end

  def display_goodbye_message
    puts "Thank you for playing. Good bye!"
  end

  def display_advanced_offer
    choice = nil
    puts "Would you like to play an advanced version? (y/n)"
    loop do
      choice = get.chomp
      break if choice == 'y'
      puts "Please type 'y' or 'n':"
    end
    @version = Version.new if choice == 'y'
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
    display_advanced_offer
    puts "You are playing against #{computer.name}. Good luck!"
  end

  def display_both_choices
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_scores
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def display_winner
    if human.move.value == computer.move.value
      puts "You both chose #{human.move}. It's a tie!"
    else
      display_both_choices
      human.beats?(computer) ? human.won : computer.won
    end
  end

  def play_again
    puts "Would you like to play again? (y/n)"
    gets.chomp
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_winner
      display_scores
      choice = play_again
      break unless choice == 'y'
    end
    display_goodbye_message
  end
end

class Player
  attr_accessor :name, :move, :score

  # WINNING_PAIRS = [['rock', 'scissors'],
  #                  ['rock', 'lizard'],
  #                  ['paper', 'rock'],
  #                  ['paper', 'spock'],
  #                  ['scissors', 'paper'],
  #                  ['scissors', 'lizard'],
  #                  ['lizard', 'spock'],
  #                  ['lizard', 'paper'],
  #                  ['spock', 'scissors'],
  #                  ['spock', 'rock']]

  WINNING_PAIRS = { 
    'rock' => ['scissors', 'lizard'],
    'paper'=> ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['spock', 'paper'],
    'spock'=> ['scissors', 'rock']
  }

  def initialize
    set_name
    @score = 0
  end

  def beats?(other_player)
    WINNING_PAIRS.each do |beater, beatees|
      next unless self.move.value == beater
      return true if beatees.include? other_player.move.value
    end
    false
  end

  def won
    puts "#{name} wins."
    self.score += 1
  end
end

class Human < Player
  def set_name
    puts "What's your name?"
    self.name = gets.chomp.capitalize
  end

  def choose
    choice = nil
    loop do
      puts "Please, choose Rock, Paper or Scissors:"
      choice = gets.chomp.downcase
      break if Move::CHOICES.include? choice
      puts "Choice is not valid. Try again:"
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['Comp', 'Titi', 'Paperclip'].sample
  end

  def choose
    self.move = Move.new(Move::CHOICES.sample)
  end
end

class Move
  attr_reader :value

  CHOICES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end
end

class Version
  attr_accessor :advanced
  
  STANDARD = ['rock', 'paper', 'scissors']
  EXTRA = ['lizard', 'spock']

  def initialize
    # puts "Would you like to play an advanced version? (y/n)"
    # loop do
    #   choice = gets.chomp.downcase
    #   if ['y', 'n'].include? choice
    #     @advanced = (choice == 'y')
    #     break
    #   end
    #   puts "Please, select 'y' or 'n'"
    # end
  end

  def self.choices
    @advanced ? STANDARD + EXTRA : STANDARD
  end

  def self.advanced?
    advanced
  end
end

RPSGame.new.play


=begin
P: add two more choices to the game: Lizard,Spock. So that the user can choose
if they would like to play a standard version or an advancced one.

A:
-ask the user if they want to play an advanced version of this game
  -check if the answer is only 'y' or 'n'
-if the user wants to play an advanced version, add two more choices tov(choices)

=end