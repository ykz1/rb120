class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end

# because line 11 is an assignment, Ruby will initialize a new local variable `quantity` but we are actually trying to reference the instance variable `@quantity`. 

# We can either
#   change to `@quantity = ...`
#   or
#   change to `self.quantity = ` and change `attr_reader` to `attr_accessor`