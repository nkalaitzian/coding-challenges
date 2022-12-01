numbers = (1...1000).to_a.select do |num|
    num % 3 == 0 || num % 5 == 0
end

puts "#{numbers.inspect}"
puts "#{numbers.sum}"
