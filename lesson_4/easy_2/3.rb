module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

puts "HotSauce > Taste > Object > Kernel > BasicObject"
p HotSauce.ancestors