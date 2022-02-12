class GuessingGame
  attr_accessor :guess, :win
  attr_reader :the_num, :min, :max, :tries

  def initialize(min=1, max=100)
    @the_num = Random.new.rand(min..max)
    @guess = 0
    @win = false
    @min = min
    @max = max
    @tries = Math.log2(max - min).to_i + 1
  end

  def play
    tries.times do |trie|
      puts "You have #{tries - trie} guesses remaining."
      player_guess
      display_result
      puts ''
      break if win
    end
    display_win_lose
  end

  def player_guess
    puts "Enter a number between #{min} and #{max}: "
    answer = nil
    loop do
      answer = gets.chomp
      break if valid? answer
      puts "Invalid guess. Enter a number between #{min} and #{max}: "
    end
    self.guess = answer.to_i
  end

  def valid?(answer)
    (min..max).cover? answer.to_i
  end

  def display_result
    message = "Your guess is too "

    case guess <=> the_num
    when -1 then puts message + "low."
    when 0
      puts "That's the number"
      self.win = true
    when 1 then puts message + "high."
    end
  end

  def display_win_lose
    puts win ? "You won!" : "You lost! The number was #{the_num}"
  end
end

game = GuessingGame.new(501, 1500)
game.play

game = GuessingGame.new
game.play
