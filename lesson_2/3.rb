class Person
  attr_accessor :first_name, :last_name

  def initialize(n)
    self.name = n
  end

  def name
    "#{@first_name} #{@last_name}".strip
  end

  def name=(n)
    @first_name = n.split[0]
    @last_name = n.split.size > 1 ? n.split[1] : ''
  end

end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
p bob.first_name            # => 'John'
p bob.last_name             # => 'Adams'