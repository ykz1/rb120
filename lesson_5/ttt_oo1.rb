=begin

Nouns: board, squares, players
Verbs: play, mark

Board
- Play
- Initialize

Squares

Players
- Initialize
- Mark

Game
- Play
- Winner

=end

class TTTGame
  attr_reader :board, :size, :human, :computer

  def initialize
    # Gather settings
    @size = 3
    # Initialize board
    @board = Board.new(size)
    # Initialize players
    @human = Player.new('X')
    @computer = Player.new('O')
  end

  def play
    display_welcome_message
    loop do
      display_board(board)
      break
      player1.move
      break if someone_won? || board_full?
      player2.move
      break if someone_won? || board_full?
    end
    # display_result
    display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end
 
  def display_goodbye_message
    puts "Thanks for playing!"
  end

  def display_board(board)
    row_display = '  '
    (1..size).each { |column| row_display += column.to_s + ' ' }
    puts row_display
    puts '-' + '--' * size
    (1..size).each do |row|
      row_display = '|'
      (1..size).each do |column|
        row_display += board[[row, column]] + '|'
      end
      puts row_display
    end
    puts '-' + '--' * size
  end

  def display_line(start, contents, breaks, end)
    row_display = start

  def human_moves
    puts "Choose a square by row and column"
  end
end

class Board
  attr_reader :board
  def initialize(size)
    @board = {}
    (1..size).each do |row|
      (1..size).each do |column|
        @board[[row, column]] = ' '
      end
    end
  end
  def [](arr_key)
    @board[arr_key]
  end
end



class Player
  attr_reader :marker
  def initialize(marker)
    @marker = marker
  end

  def mark
  end
end


game = TTTGame.new
game.play
