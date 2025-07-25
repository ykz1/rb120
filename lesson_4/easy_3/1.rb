class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end


hello = Hello.new
puts "Hello will be printed"
hello.hi

hello = Hello.new
begin
  puts
  puts "Exception will be thrown: no method bye"
  hello.bye
rescue => e
  puts e.message
end

hello = Hello.new
begin
  puts
  puts "Exception will be thrown: wrong arguments"
  hello.greet
rescue => e
  puts e.message
end


hello = Hello.new
puts
puts "Goodbye will be printed"
hello.greet("Goodbye")

puts
puts "Exception thrown: no method"
begin
  Hello.hi
rescue => e
  puts e
end