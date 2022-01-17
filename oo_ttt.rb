require 'pry'

class TTTGame
  attr_reader :board, :human, :computer, :current_player

  @@human_marker = 'X'
  @@computer_marker = 'O'

  def initialize
    @board = Board.new
    @human = Player.new(@@human_marker)
    @computer = Player.new(@@computer_marker)
    @computer.name = ['Computer', 'Paperclip', 'Natasha'].sample
    @current_player = @human
  end

  def clear
    system 'clear'
  end

  def display_board(clear_screen: true)
    clear if clear_screen
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    board.draw
  end

  def pause
    puts ''
    puts "Press any key when you're ready:"
    gets.chomp
  end

  def play
    clear
    display_welcome
    pause
    main_play
    display_goodbye
  end

  def main_play
    loop do
      display_board
      display_score

      moves

      display_board
      display_result
      display_score

      play_again? ? reset : break
    end
  end

  def moves
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      display_board
      display_score
    end
  end

  def current_player_moves
    if @current_player == human
      human_moves
      @current_player = computer
    else
      computer_moves
      @current_player = human
    end
  end

  def display_score
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    answer = nil
    loop do
      answer = gets.chomp
      break if ['y', 'n'].include? answer
      puts "Answer is not valid."
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_player = human
    puts ''
    puts "Great! Let's play again!"
    pause
  end

  def human_moves
    puts "Choose a square (#{join_or board.unmarked_squares}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_squares.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def join_or(arr)
    if arr.length > 1
      arr[0...-1].join(', ') + " or #{arr[-1]}"
    else
      arr.join
    end
  end

  def display_result
    case board.winning_marker
    when human.marker
      puts "You won!"
      human.scores
    when computer.marker
      puts "#{computer.name} won!"
      computer.scores
    else
      puts "It's a tie."
    end
  end

  def computer_moves
    square = nil
    Board::WIN_LINES.each do |line|
      square = find_threat(line, board.squares)
      break if square
    end

    square = mid_rand if !square

    board[square] = computer.marker
  end

  def mid_rand
    if board.unmarked_squares.include? 5
      5
    else
      board.unmarked_squares.sample
    end
  end

  def find_threat(lines, brd)
    if brd.values_at(*lines).map(&:marker).count(computer.marker) == 2
      brd.select { |k, v| lines.include?(k) && v.marker == ' ' }.keys.first
    elsif brd.values_at(*lines).map(&:marker).count(human.marker) == 2
      brd.select { |k, v| lines.include?(k) && v.marker == ' ' }.keys.first
    end
  end

  def display_welcome
    puts 'Welcome to Tic Tac Toe!'
    puts ''
    puts "What's your name?"
    human.name = gets.chomp.capitalize
    puts ''
    puts "Choose your marker, or skip (Enter):"
    human_marker = gets.chomp
    human.marker = human_marker unless human_marker.empty?
  end

  def display_goodbye
    puts "Thank you for playing Tic Tac Toe! Goodbye."
  end
end

class Board
  attr_reader :squares

  INITIAL_MARKER = ' '
  WIN_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
              [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
              [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    (1..9).each { |n| @squares[n] = Square.new(INITIAL_MARKER) }
  end

  def draw
    puts ''
    puts filler
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}  "
    puts_divider
    puts filler
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}  "
    puts_divider
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}  "
    puts filler
    puts ''
  end

  def filler
    "     |     |"
  end

  def puts_divider
    puts filler
    puts "-----+-----+-----"
    puts filler
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_squares
    @squares.select { |_, v| v.unmarked? }.keys
  end

  def full?
    unmarked_squares.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WIN_LINES.each do |line|
      next if line.any? { |sq| @squares[sq].marker == INITIAL_MARKER }
      marker = @squares[line.first].marker
      return marker if line.all? { |sq| @squares[sq].marker == marker }
    end
    nil
  end

  def reset
    initialize
  end
end

class Square
  attr_accessor :marker

  def initialize(marker)
    @marker = marker
  end

  def to_s
    marker
  end

  def unmarked?
    marker == Board::INITIAL_MARKER
  end
end

class Player
  attr_reader :score
  attr_accessor :name, :marker

  def initialize(marker)
    @marker = marker
    @score = 0
    @name = 'You'
  end

  def scores
    @score += 1
  end
end

game = TTTGame.new
game.play
