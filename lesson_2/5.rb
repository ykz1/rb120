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

  def to_s
    name
  end
end

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"