# rubocop:disable Layout/LineLength
# Notes for bonus assignment:
# - Decided against implementing a class for each of the 5 moves. Hypothetically...these would be sub-classes of Move and each have their own `>` method returning true if `other_move.value` is a move they defeat, and a `to_s` method which returns their class name in string
# - For history of moves, implemented an array structure storing simple string logs of game activity. Alternatively can save log as:
#   - Variable to save player name
#   - Variable to save computer name
#   - Array of games, each a hash with keys :winner (winner name), :loser (loser name), :rounds (array of rounds, see below)
#   - Array of rounds, each a hash with keys :player (player move selected), :computer (computer move), :winner (winner name)
# rubocop:enable Layout/LineLength

class Move
  attr_reader :value

  VALUES = %w(rock paper scissors lizard spock)

  def initialize(value)
    @value = value
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  def >(other_move)
    opponent = other_move.value
    case value
    when 'rock' then opponent == 'scissors' || opponent == 'lizard'
    when 'paper' then opponent == 'rock' || opponent == 'spock'
    when 'scissors' then opponent == 'paper' || opponent == 'lizard'
    when 'lizard' then opponent == 'spock' || opponent == 'paper'
    when 'spock' then opponent == 'rock' || opponent == 'scissors'
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
end

class Player
  attr_accessor :move, :name, :score

  def initialize(type = :human)
    @type = type
    @move = nil
    @score = 0
    set_name
  end
end

class Human < Player
  def set_name
    n = nil
    system 'clear'
    puts '=============='
    loop do
      puts "Whats your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Please enter a value"
    end
    self.name = n
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def choose
    choice = nil
    system 'clear'
    puts '=============='
    loop do
      puts "Please choose from: #{Move::VALUES.join(', ')}"
      choice = gets.chomp.downcase
      if Move::VALUES.map { |move| move[0..1] }.include?(choice[0..1])
        choice = Move::VALUES.find { |move| move[0..1] == choice[0..1] }
        break
      end
      puts "Invalid choice!"
    end
    self.move = Move.new(choice)
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end

class Computer < Player
  DEFAULT_NAMES = %w(R2D2 Hal iRobot)
  def set_name
    self.name = DEFAULT_NAMES.sample
  end

  def choose
    choice = case name
             when 'R2D2' then 'rock'
             when 'Hal' then %w(scissors scissors rock spock lizard).sample
             else Move::VALUES.sample
             end
    self.move = Move.new(choice)
  end
end

class RPSGame
  TOTAL_GAMES = 3

  def initialize
    @human = Human.new(:human)
    @computer = Computer.new(:computer)
    @round = 1
    @log = Log.new
  end

  # rubocop:disable Metrics/MethodLength
  def play
    display_welcome_message
    loop do
      loop do
        human.choose
        computer.choose
        display_results
        self.round += 1
        break if [human.score, computer.score].max == TOTAL_GAMES
      end
      display_game_results
      break unless play_again?
    end
    display_goodbye_message
  end
  # rubocop:enable Metrics/MethodLength

  private

  attr_accessor :human, :computer, :round, :log

  def display_welcome_message
    system 'clear'
    puts '=============='
    puts "Welcome to OO RPS"
    puts
  end

  def display_results
    system 'clear'
    puts '=============='
    log.add "Round #{round}:"
    display_moves
    display_outcome
    puts "Press enter to continue..."
    gets
  end

  def display_moves
    log.add "#{human.name} chose #{human.move.value}"
    log.add "#{computer.name} chose #{computer.move.value}"
    puts
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def display_outcome
    if human.move > computer.move
      log.add "#{human.name} wins the round!"
      human.score += 1
    elsif computer.move > human.move
      log.add "#{computer.name} wins the round!"
      computer.score += 1
    else
      log.add "It's a tie!"
    end
    puts
    puts "#{human.name}: #{human.score} | #{computer.name}: #{computer.score}"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def display_game_results
    winner = [human, computer].find { |player| player.score == TOTAL_GAMES }
    puts "#{winner.name} wins the game in round #{round}!"
    puts
  end

  def display_goodbye_message
    puts
    puts "Thanks for playing!"
    puts "Enter (l) to see history log, or anything else to exit"
    log.print if gets.chomp == 'l'
  end

  def play_again?
    choice = nil
    loop do
      puts "Would you like to play again?"
      choice = gets.chomp.downcase[0]
      break if %w(y n).include? choice
      puts "Invalid choice, please enter 'y' or 'n'"
    end
    choice == 'y'
  end
end

class Log
  def initialize
    @log = []
  end

  def add(str)
    puts str
    @log << str
  end

  def print
    puts @log
  end
end

#### Game code

RPSGame.new.play
