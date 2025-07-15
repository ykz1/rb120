module Pivot
end

class Builder
  include Pivot
end


kyle = Builder.new

p kyle.class.ancestors

# Modules are similar to classes in that they contain behaviours / methods; however no objects can be created from modules. To access a module's behaviours / methods, it must be mixed-in to a Class with #include.