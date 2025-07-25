class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end

  def play
    # this method would supercede Game#play when #play is called on an instance of Bingo
end