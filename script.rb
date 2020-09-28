require_relative 'src/checkout.rb'

RULES = File.read('default_rules.txt').split("\n").reject(&:empty?)

def help!
  puts "The following rules works here:"
  RULES.each { |rule| puts "- #{rule}" }
  puts "\n- Enter the set of selected goods (e.g.: A, B, C, D, A)"
  puts "- To exit type 'exit', 'e' or 'q'"
  puts "- Enjoy your shopping (money back guaranteed by Yukihiro Matsumoto)\n\n\n"
end

puts "\n\n\nWelcome to the Demo Basket script!"
help!

30.times do |i|
  print "#{i+1}> "
  input = gets.chomp

  if %w(exit e q).include?(input)
    puts "\nSo long!"
    break
  end

  if input.downcase.start_with?("help")
    help!
    next
  end

  co = Checkout.new(RULES)
  input.split(/[ ,]/).reject(&:empty?).each { |item| co.scan(item.strip) }

  puts "The basket total is £#{co.total}\n\n"
end

