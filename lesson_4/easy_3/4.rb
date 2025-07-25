class Cat
  def initialize(type)
    @type = type
  end
end

puts "<Cat:SOMETEXT> will be printed"
puts Cat.new('cat')

class Cat2
  def initialize(type)
    @type = type
  end
  def to_s
    "I am a #{@type} cat"
  end
end

puts "I am a sassy cat"
puts Cat2.new('sassy')