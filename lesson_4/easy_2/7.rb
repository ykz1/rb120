class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# @@cats_count is a class variable, it is initialized at 0, then incremented by +1 with any instantiation of instance of Cat.


p Cat.cats_count

Cat.new('cheshire')
p Cat.cats_count