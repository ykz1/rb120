class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template  # This references a local variable 
  end
end

class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    self.template
  end
end

# The end result is the same—namely that instance variable `@template` is returned, but the two implementations take two ways of getting there. The first tries to find a local variable `template`, but is not found, and then Ruby will proceed to look for an in-scope method `template` which it finds as an instant method in the `Computer` class. In the second, because `self` is prepended, Ruby will find the getter method `Computer#template` to return the instance variable `@template`.