class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Ben is right because of getter for balance. No local variable balance is found so Ruby will look for a method with name and subsequently find balance's getter method as defined by attr_reader

