
class Vehicle
  @@count = 0
  def initialize
    @@count += 1

    @year = year
    @color = color
    @model = model
    @speed = 0

  end

  def age
    "#{calculate_age} years old"
  end

  def accelerate(number)
    @speed += number
  end

  def brake(number)
    @speed -= brake
  end

  def shut_off
    @speed = 0
  end

  def spray_paint(color)
    self.color = color
  end

  def self.mileage(gallons, miles)
    puts "#{miles / gallons} MPG"
  end

  def to_s
    "#{@year} #{model}"
  end

  private

  def calculate_age
    Time.now.year - self.year
  end

end

module Towable
  def can_tow?
    'Yes'
  end
end

class MyTruck < Vehicle
  TRAIT = 'Larger four wheels'
  include Towable
end

class MyCar < Vehicle
  attr_accessor :color
  attr_reader :year

  TRAITS = 'Smaller four wheels'


  

end

p MyTruck.ancestors