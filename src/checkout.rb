require_relative './rule.rb'

class Checkout
  attr_reader :goods

  def initialize(lines_of_rules)
    @rules = lines_of_rules.map { |line| Rule.new(line) }
    @goods = Hash.new(0)
  end

  def feed(line_of_items)
    line_of_items
      .split(/[ ,]/)
      .map(&:strip)
      .reject { |item| item.size.zero? }
      .each { |item| scan(item) }
  end

  def scan(item)
    goods[item] += 1
  end

  def total
    sum = 0
    price_rules
      .concat(partial_discount_rules)
      .each { |rule| sum = rule.apply(goods: goods, sum: sum) }
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
