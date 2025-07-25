class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count # self here means we are defining a class method i.e. a method on the Cat class rather than instances of Cat
    @@cats_count
  end
end