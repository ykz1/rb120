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
    print_header
    print_horizontal_line
    print_rows
    print_horizontal_line
  end

  def column_padding(str1, str2)
    " #{str1} #{str2}"
  end

  def print_header
    line = column_padding(' ', ' ')
    (1..size).each do |num|
      line += " #{num}  "
    end
    puts line
  end

  def print_horizontal_line(intersection='-')
    line = column_padding(' ', ' ')
    line += ("---#{intersection}" * (size - 1))
    line += '---'
    puts line
  end

  def print_rows
    (1..size).each do |row|
      line = column_padding(row.to_s, '|')
      (1..size).each do |column|
        key = row.to_s + column.to_s
        line += " #{@squares[key]} |"
      end
      puts line
      print_horizontal_line('+') unless row == size
    end
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

  def winning_moves(marker)
    @winning_lines.each_with_object([]) do |line, winning_moves|
      if @squares.values_at(*line).map(&:marker).count(marker) == (size - 1)
        winning_moves << line.select { |key| @squares[key].unmarked? }
      end
    end.flatten
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
  COMPUTER_NAMES = ['Hal', 'R2D2', 'ChatGPT', 'Claude']
  attr_accessor :marker, :name, :score, :games_won, :type, :difficulty

  def initialize(type)
    @type = type
    @score = 0
    @games_won = 0
  end

  def pick_name
    input = ''
    puts
    loop do
      puts 'What is your name?'
      input = gets.chomp
      break unless input.empty?
      puts 'No input detected.'
    end
    @name = input
  end

  def generate_name
    @name = COMPUTER_NAMES.sample
  end

  def pick_markers
    input = ''
    puts
    loop do
      puts 'Would you like to be X or O?'
      input = gets.chomp.downcase
      break if %w(x o).include?(input)
      puts 'Invalid choice.'
    end
    @marker = input.upcase
  end

  def set_marker(other_marker)
    @marker = (other_marker == 'X' ? 'O' : 'X')
  end

  def move(board)
    (type == 'Human') ? human_moves(board) : computer_moves(board)
  end

  def human_moves(board)
    square = ''

    loop do
      puts "Choose an empty square: #{board.empty_square_keys.join(', ')}"
      square = gets.chomp
      break if board.empty_square?(square)
      puts "Invalid move."
    end

    board[square] = marker
  end

  def computer_moves(board)
    random_move = board.empty_square_keys.sample
    opponent_marker = (marker == 'X' ? 'O' : 'X')
    defensive_moves = board.winning_moves(opponent_marker)
    offensive_moves = board.winning_moves(marker)

    key = case difficulty
          when 1 then random_move
          when 2 then [random_move, defensive_moves].flatten.last
          when 3 then [random_move, defensive_moves, offensive_moves].flatten.last
          end

    board[key] = marker
  end
end

# GAME CLASS =====================================

class TTTGame

  def play
    display_welcome_message
    set_game_settings
    main_game
    display_goodbye_message
  end

  private

  attr_reader :board, :human, :computer, :first_to_go, :current_player, :round, :rounds_to_win, :game_count

  def initialize
    @human = Player.new('Human')
    @computer = Player.new('Computer')
    @round = 0
    @game_count = 0
  end

  def set_game_settings
    human.pick_name
    computer.generate_name

    human.pick_markers
    computer.set_marker(human.marker)

    determine_order
    determine_rounds_per_game
    determine_board_size
    determine_computer_difficulty

    display_settings
  end

  def determine_order
    input = ''
    puts
    loop do
      puts "Who goes first? (1) #{human.name}, (2) #{computer.name}"
      input = gets.chomp
      break if %w(1 2).include?(input)
      puts 'Invalid entry.'
    end
    @first_to_go = (input == '1' ? human : computer)
    @current_player = first_to_go
  end

  def determine_rounds_per_game
    input = ''
    puts
    loop do
      puts 'How many rounds to win a game? Pick between 1 ~ 9'
      input = gets.chomp
      break if (1..9).include?(input.to_i)
      puts 'Invalid entry.'
    end
    @rounds_to_win = input.to_i
  end

  def determine_board_size
    input = ''
    puts
    loop do
      puts 'What size board would you like to play on? 3 ~ 9'
      input = gets.chomp.to_i
      break if (1..9).include?(input)
      puts 'Invalid choice.'
    end
    @board = Board.new(input)
  end

  def determine_computer_difficulty
    input = ''
    puts
    loop do
      puts 'What difficulty would you like to play against? (1) easy; (2) medium; (3) hard'
      input = gets.chomp
      break if %w(1 2 3).include?(input)
      puts 'Invalid choice.'
    end
    computer.difficulty = input.to_i
  end

  def display_settings
    clear
    puts '============================='
    puts "#{human.name} will be playing as #{human.marker} against #{computer.name} with the #{computer.marker}s!"
    puts "The game will be played on a #{board.size} x #{board.size} board."
    puts "First to #{rounds_to_win} wins the game."
    puts "#{@first_to_go.name} goes first."
    puts
    puts "Press enter to continue..."
    gets.chomp
  end

  def main_game
    @game_count += 1
    loop do
      loop do
        @round += 1
        display_board
        players_take_turns
        save_and_display_round_results
        break if game_winner?
        reset_round
      end
      save_and_display_game_results
      break unless play_again?
      reset_game
    end
  end

  def players_take_turns
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      display_board
    end
  end

  def display_welcome_message
    clear
    puts '============================='
    puts "Welcome to Tic Tac Toe!"
    puts
  end

  def display_goodbye_message
    puts
    puts "Thanks for playing!"
  end

  def display_board
    # rubocop:disable Layout/LineLength
    clear
    puts '============================='
    puts "Game #{game_count} - Round #{round}"
    puts "Games:   #{human.name} - #{human.games_won} | #{computer.games_won} - #{computer.name}"
    puts "Rounds:  #{human.name} - #{human.score} | #{computer.score} - #{computer.name}"
    puts "Markers: #{human.name} - #{human.marker} | #{computer.marker} - #{computer.name}"
    # rubocop:enable Layout/LineLength
    puts
    board.draw
    puts
  end

  def clear
    system 'clear'
  end

  def current_player_moves
    if current_player == human
      human.move(board)
      @current_player = computer
    else
      computer.move(board)
      @current_player = human
    end
  end

  def save_and_display_round_results
    display_board
    case board.winning_marker
    when human.marker
      puts "#{human.name} wins round #{round}!"
      human.score += 1
    when computer.marker
      puts "#{computer.name} wins round #{round}!"
      computer.score += 1
    else
      puts "Round #{round} ends in a tie."
    end
    
    unless game_winner?
      puts "Press enter to begin round #{round + 1}..."
      gets
    end
  end

  def game_winner?
    [human.score, computer.score].max == rounds_to_win
  end

  # rubocop:disable Layout/LineLength
  # rubocop:disable Metrics/AbcSize
  def save_and_display_game_results
    if human.score == rounds_to_win
      human.games_won += 1
      display_board
      puts "#{human.name} wins the game (#{human.score} - #{computer.score}) in round #{round}!"
    elsif computer.score == rounds_to_win
      computer.games_won += 1
      display_board
      puts "#{computer.name} wins the game (#{computer.score} - #{human.score}) in round #{round}!"
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Layout/LineLength

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

  def reset_round
    board.reset
    @current_player = first_to_go
    clear
  end

  def reset_game
    reset_round
    @round = 0
    human.score = 0
    computer.score = 0
  end
end

# PLAY CODE =====================================

TTTGame.new.play
