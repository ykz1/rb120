# BOARD CLASS =====================================
class Board
  attr_reader :size

  def initialize(board_size)
    @size = board_size
    generate_board
    generate_winning_lines
  end

  def reset
    generate_board
  end

  def generate_board
    @squares = {}
    (1..size).each do |row|
      (1..size).each do |column|
        key = row.to_s + column.to_s
        @squares[key] = Square.new
      end
    end
  end

  def generate_winning_lines
    @winning_lines = []
    winning_diagonal1 = []
    winning_diagonal2 = []

    (1..size).each do |line|
      @winning_lines << generate_row_keys(line)
      @winning_lines << generate_column_keys(line)
      winning_diagonal1 << (line.to_s * 2)
      winning_diagonal2 << ((size + 1 - line).to_s + line.to_s)
    end

    @winning_lines.push(winning_diagonal1, winning_diagonal2)
  end

  def generate_row_keys(row_num)
    @squares.keys.select { |key| key[0] == row_num.to_s }
  end

  def generate_column_keys(column_num)
    @squares.keys.select { |key| key[1] == column_num.to_s }
  end

  def draw
    puts "     1   2   3  "
    puts "    ----------- "
    puts " 1 | #{@squares['11']} | #{@squares['12']} | #{@squares['13']} |"
    puts "   |---+---+---|"
    puts " 2 | #{@squares['21']} | #{@squares['22']} | #{@squares['23']} |"
    puts "   |---+---+---|"
    puts " 3 | #{@squares['31']} | #{@squares['32']} | #{@squares['33']} |"
    puts "    ----------- "
  end

  def empty_square?(key)
    empty_square_keys.include?(key)
  end

  def empty_square_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def full?
    empty_square_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    @winning_lines.each do |line|
      first_square = @squares[line[0]]
      next if first_square.unmarked?
      markers_in_line = @squares.values_at(*line).map(&:marker)
      return first_square.marker if markers_in_line.uniq.count == 1
    end
    nil
  end

  def to_s
    @squares
  end
end

# SQUARE CLASS =====================================

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def to_s
    @marker
  end
end

# PLAYER CLASS =====================================

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

# GAME CLASS =====================================

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  def play
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  attr_reader :board, :board_size, :human, :computer, :current_player

  def main_game
    loop do
      display_board
      players_take_turns
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def players_take_turns
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board
    end
  end

  def initialize
    # Initialize game settings
    @board_size = 3

    # Initialize board
    @board = Board.new(board_size)

    # Initialize players
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_player = first_player
  end

  def first_player
    human
  end

  def display_welcome_message
    clear
    puts "Welcome to Tic Tac Toe!"
  end

  def display_goodbye_message
    puts "Thanks for playing!"
  end

  def display_board
    puts "You are #{human.marker}. Computer is #{computer.marker}"
    puts
    board.draw
    puts
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def clear
    system 'clear'
  end

  def human_moves
    square = ''

    loop do
      puts "Choose an empty square: #{board.empty_square_keys.join(', ')}"
      square = gets.chomp
      break if board.empty_square?(square)
      puts "Invalid move."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[board.empty_square_keys.sample] = computer.marker
  end

  def current_player_moves
    if current_player == human
      human_moves
      @current_player = computer
    else
      computer_moves
      @current_player = human
    end
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You win!"
    when computer.marker
      puts "Computer wins!"
    else
      puts "It's a tie."
    end
  end

  def play_again?
    input = ''
    loop do
      puts "Would you like to play again? (y/n)"
      input = gets.chomp[0]
      break if %w(y n).include?(input)
      puts "Invalid input."
    end
    input == 'y'
  end

  def reset
    board.reset
    @current_player = first_player
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts
  end
end

# PLAY CODE =====================================

TTTGame.new.play
