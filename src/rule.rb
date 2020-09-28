require 'pry'

class Rule
  attr_reader :target, :type, :args

  def initialize(line)
    @target, @type, *@args = line.split(',').map(&:strip)
  end

  def price?
    type == 'price'
  end

  def apply(goods:, sum:)
    if price?
      binding.pry
      sum + goods[target] * args[0].to_i
    end
  end
end
