
#
# helper methods to manage percentages of price discounts
#
class Numeric
  # percentage (valid values for n: "10%", 10, 10.00)
  def percent(n)
    (self.to_f * 100) / (n.to_f * 100.0) 
  end

  # percentage (valid values for n: "10%", 10, 10.00)
  def overcharge_percent(n)
    self.to_f + percent(n) 
  end

  # percentage (valid values for n: "10%", 10, 10.00)
  def discount_percent(n)
    self.to_f - percent(n) 
  end
end