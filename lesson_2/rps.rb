=begin

Nouns (Classes) and verbs (methods):

Player
- Choose move

Rule / Move
- Compare

Game
- Play

=end

class Move
  attr_reader :value

  VALUES = %w(rock paper scissors)

  def initialize(value)
    @value = value
  end

  def >(other_move)
    case value
    when 'rock' then other_move.value == 'scissors'
    when 'paper' then other_move.value == 'rock'
    when 'scissors' then other_move.value == 'paper'
    end
  end
end

class Player
  attr_accessor :move, :name

  def initialize(type = :human)
    @type = type
    @move = nil
    set_name
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "Whats your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Please enter a value"
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose: rock, paper, or scissors:"
      choice = gets.chomp
      break if ['rock', 'paper', 'scissors'].include?(choice)
      puts "Invalid choice!"
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new(:human)
    @computer = Computer.new(:computer)
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_results
      break unless play_again?
    end
    display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to OO RPS"
    puts
  end

  def display_results
    display_moves
    if human.move > computer.move
      puts "#{human.name} wins!"
    elsif computer.move > human.move
      puts "#{computer.name} wins!"
    else
      puts "It's a tie!"
    end
    puts
  end

  def display_moves
    puts
    puts "#{human.name} chose #{human.move.value}"
    puts "#{computer.name} chose #{computer.move.value}"
    puts
  end

  def display_goodbye_message
    puts "Thanks for playing!"
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

#### Game code

RPSGame.new.play
