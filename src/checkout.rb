require_relative './rule.rb'

class Checkout
  attr_reader :goods

  def initialize(lines_of_rules)
    @rules = lines_of_rules.map { |line| Rule.new(line) }
  end

  def scan(item)
  end

  def total
    sum = 0
    price_rules.each { |rule| sum = rule.apply(goods: goods, sum: sum) }
    sum
  end

  private

  def price_rules
    @rules.select(&:price?)
  end

  def partial_discount_rules
    @rules.select(&:partial_discount?)
  end

  def total_discount_rules
    @rules.select(&:total_discount?)
  end
end
