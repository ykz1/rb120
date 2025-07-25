class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1 # self tells Ruby to use the setter method rather than initialize a new local variable age. Can replace self. with @
    @age += 1
  end
end