require 'pry-byebug'
=begin

Deck
- Shuffle
- Draw
Cards < Deck

Players
- Has Hand
- hit
- stay
- busted?
- total_points
player < Players
Dealer < Players

Hand
- Has Cards
- Calculate points


21Game


=end

# =============================================================================
# DECK CLASS

class Deck
  SUITES = %w(Diamonds Clubs Hearts Spades)
  FACES = %w(A 2 3 4 5 6 7 8 9 T J Q K)

  attr_accessor :deck

  def initialize
    generate_cards
    deck.shuffle!
  end

  def generate_cards
    @deck = []
    SUITES.each do |suite|
      FACES.each do |face|
        card = Card.new
        card.name = "#{face} of #{suite}"
        card.points = case face
                      when 'A' then [11, 1]
                      when ('2'..'9') then [face.to_i]
                      else [10]
                      end
        deck << card
      end
    end
  end

  def deal(participant, announce=false)
    drawn_card = deck.pop
    drawn_card.position = participant.name
    participant.hand << drawn_card
    if announce
      print "#{participant.name} draws"
      3.times do
        sleep (0.5)
        print '.'
      end
      puts " #{drawn_card.name}!"
      puts
      sleep 1
    end
  end

  def to_s
    deck
  end

  def reset(participants)
    participants.each do |participant|
      until participant.hand.empty?
        returning_card = participant.hand.pop
        returning_card.position = 'Deck'
        deck << returning_card
      end
    end
    deck.shuffle!
  end

end

# =============================================================================
# CARD CLASS

class Card
  @@all_cards = []

  attr_accessor :name, :points, :position
  def initialize
    @name = nil
    @points = nil
    @position = 'Deck'
    @@all_cards << self
  end

  def self.all
    @@all_cards
  end

end

# =============================================================================
# PLAYER CLASS

class Player
  COMPUTER_NAMES = %w(R2D2 WallE C3PO Hall9000 ChatGPT)
  attr_accessor :type, :name, :hand, :points, :score

  def initialize(type)
    @type = type
    @hand = []
    @name = COMPUTER_NAMES.sample if type == 'Dealer'
    @score = 0
  end

  def show_table_cards
    puts "#{name} showing: #{hand.first.name} and #{hand.size - 1} hidden cards."
  end

  def show_all_cards_and_points
    puts "#{name}'s hand: #{points} with #{cards_in_hand}"
  end

  def cards_in_hand
    hand.map(&:name).join(', ')
  end

  def possible_points
    card_points = hand.map(&:points)
    point_combinations = card_points[0].product(*card_points[1..-1])
    possible_points = point_combinations.map(&:sum).sort
  end
end

# =============================================================================
# GAME ORCHESTRATION CLASS

class BJGame  

  def play
    display_pregame_message
    collect_settings
    loop do
      main_game
      break unless play_again?
      reset
    end
    display_goodbye_message
  end
  
  private
  
  attr_accessor :player, :dealer, :deck, :blackjack_points, :dealer_hit_max, :rounds_per_game

  def initialize
    @deck = Deck.new
    @player = Player.new('Player')
    @dealer = Player.new('Dealer')
    @blackjack_points = 21
    @rounds_per_game = 3
  end
  
  # PRE-GAME ==================================================================

  def display_pregame_message
    system 'clear'
    puts '========================='
    puts 'Welcome to BlackJack(ish)!'
    puts
    puts 'Current settings:'
    puts "1) Player name: #{player.name}"
    puts "2) Dealer name: #{dealer.name}"
    puts "3) BlackJack: #{blackjack_points}"
    puts "4) Rounds per game: #{rounds_per_game}"
    puts
  end

  def collect_settings
    ask_for_player_name
    ask_for_dealer_name
    ask_for_blackjack_points
    display_settings_prompt_continue
  end
  
  def ask_for_player_name
    display_pregame_message
    input = ''
    loop do
      puts 'What is your name?'
      input = gets.chomp
      break unless input.empty?
      puts 'Invalid: nothing entered!'
    end
    player.name = input
  end
  
  def ask_for_dealer_name
    display_pregame_message
    puts "What is your opponent's name?"
    input = gets.chomp
    dealer.name = input unless input.empty?
  end
  
  def ask_for_blackjack_points
    display_pregame_message
    input = ''
    loop do
      puts 'How many points should BlackJack be? (21 ~ 99)'
      input = gets.chomp.to_i
      break if (21..99).include?(input)
    end
    @blackjack_points = input
    @dealer_hit_max = blackjack_points - 4
  end

  def display_settings_prompt_continue
    display_pregame_message
    prompt_to_continue
  end

  def prompt_to_continue
    puts
    puts 'Press enter to continue...'
    gets
  end

  # MAIN GAME =================================================================

  def main_game
    deal_initial_cards
    take_player_turn
    take_dealer_turn unless busted?(player)
    display_results
  end

  def deal_initial_cards
    2.times do
      deck.deal(player)
      deck.deal(dealer)
    end
    player.points = calculate_points(player)
    dealer.points = calculate_points(dealer)
  end

  def calculate_points(participant)
    possible_points = participant.possible_points
    return 'Busted' if possible_points.min > blackjack_points
    possible_points.select { |points| points <= blackjack_points }.max
  end

  def display_table(show_dealer_cards=false)
    system 'clear'
    puts '========================='
    puts "Score: #{player.name} - #{player.score} | #{dealer.score} - #{dealer.name}"
    puts
    show_dealer_cards ? dealer.show_all_cards_and_points : dealer.show_table_cards
    player.show_all_cards_and_points
    puts
  end

  def take_player_turn
    display_table
    loop do
      case player_action
      when 'h'
        hit(player)
        break if busted_or_blackjack?(player)
      when 's' 
        stay(player)
        break
      end
    end
    prompt_to_continue
  end

  def busted_or_blackjack?(participant)
    if busted?(participant)
      puts "#{participant.name} is bust!"
      return true
    end

    if blackjack?(participant)
      puts "#{participant.name} has BlackJack!"
      return true
    end
    false
  end

  def player_action
    puts
    puts 'Would you like to (h)it or (s)tay?'
    input = ''
    loop do 
      input = gets.chomp.downcase
      puts
      break if %w(h s).include?(input)
      puts 'Invalid choice, please enter (h) or (s)'
    end
    input
  end

  def take_dealer_turn
    display_table(true)
    puts
    loop do
      sleep(1)
      puts
      if busted_or_blackjack?(dealer)
        break
      elsif dealer_above_max?
        stay(dealer)
        break
      else
        hit(dealer)
      end
    end
    prompt_to_continue
  end

  def dealer_above_max?
    dealer.points >= dealer_hit_max
  end

  def hit(participant)
    deck.deal(participant, true)
    participant.points = calculate_points(participant)
    participant.show_all_cards_and_points unless busted?(participant)
  end

  def stay(participant)
    puts "#{participant.name} stays at #{participant.points} with #{participant.cards_in_hand}"
  end

  def busted?(participant)
    participant.possible_points.min > blackjack_points
  end

  def blackjack?(participant)
    participant.points == blackjack_points
  end

  def display_results
    display_table(true)
    puts
    sleep(1)

    if winner == nil
      puts "It's a tie!"
      return
    end
    puts "#{winner.name} wins!"
    winner.score += 1
  end

  def winner
    return dealer if busted?(player)
    return player if busted?(dealer)
    case player.points <=> dealer.points
    when 1 then return player
    when -1 then return dealer
    end
    nil
  end

  def display_goodbye_message
    puts
    puts 'Thanks for playing!'
  end

  def play_again?
    puts
    input = ''
    loop do
      puts 'Would you like to play again? (Y)es / (N)o'
      input = gets.chomp[0].downcase
      break if %w(y n).include?(input)
      puts 'Invalid entry.'
    end
    input == 'y'
  end
end

def reset
  deck.reset([player, dealer])
  binding.pry
end


# =============================================================================
# EXECUTION CODE

BJGame.new.play