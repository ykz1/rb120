class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def light_status
    "I have a brightness level of #{brightness} and a color of #{color}"
  end

end

# Change to `Light#status` because it is likely that variable names used to reference Light objects will contain the text 'light' and so there is no need to repeat the class name within the instance method. Example below:

bedroom_light = Light.new
bedroom_light.status