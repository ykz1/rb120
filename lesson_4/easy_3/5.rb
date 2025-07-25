class Television
  def self.manufacturer
    puts "Sony"
  end

  def model
    puts "asdf123"
  end
end

tv = Television.new

puts "no method error"
tv.manufacturer rescue puts $!

puts
puts "asdf123"
tv.model

puts
puts "Sony"
Television.manufacturer

puts
puts "no method error"
Television.model rescue puts $!