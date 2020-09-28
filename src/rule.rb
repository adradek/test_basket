require 'pry'

class Rule
  attr_reader :target, :type, :args

  def initialize(line)
    @target, @type, *@args = line.split(',').map(&:strip)
  end

  def price?
    type == 'price'
  end

  def partial_discount?
    ["quantitive discount"].include?(type)
  end

  def apply(goods:, sum:)
    case type
    when "price"
      sum + goods[target] * args[0].to_i
    when "quantitive discount"
      sum - goods[target] / args[0].to_i * args[1].to_i
    else
      sum
    end
  end
end
