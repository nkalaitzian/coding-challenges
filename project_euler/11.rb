file_contents = File.open('11.input.txt', 'r').read
lines = file_contents.split("\n")
@array = lines.map { |l| l.split("\s").map(&:to_i) }

def products(y, x)
  [product_of_right(y, x), product_of_left(y, x), product_of_up(y, x), product_of_down(y, x),
   product_of_diagonal_left_down(y, x), product_of_diagonal_left_up(y, x),
   product_of_diagonal_right_down(y, x), product_of_diagonal_right_up(y, x)]
end

def product_of_right(y, x)
  [@array[y][x..-1]].flatten.first(4).inject(:*)
end

def product_of_left(y, x)
  target = x > 0 ? 0..x : 0
  [@array[y][target]].flatten.last(4).inject(:*)
end

def product_of_up(y, x)
  target = y > 0 ? 0..y : 0
  [@array[target].map { |row| row[x] }].flatten.last(4).inject(:*)
end

def product_of_down(y, x)
  [@array[y..-1].map { |row| row[x] }].flatten.first(4).inject(:*)
end

def product_of_diagonal_right_down(y, x)
  ([@array[y][x]] + 3.times.map do |time|
    y_target = y + time
    x_target = x + time
    next if y_target > @array.count - 1 || x_target > @array.count - 1 || y_target < 0 || x_target < 0
    @array[y_target][x_target]
  end).flatten.compact.inject(:*)
end

def product_of_diagonal_left_down(y, x)
  ([@array[y][x]] + 3.times.map do |time|
    y_target = y + time
    x_target = x - time
    next if y_target > @array.count - 1 || x_target > @array.count - 1 || y_target < 0 || x_target < 0
    @array[y_target][x_target]
  end).flatten.compact.inject(:*)
end

def product_of_diagonal_left_up(y, x)
  ([@array[y][x]] + 3.times.map do |time|
    y_target = y - time
    x_target = x - time
    next if y_target > @array.count - 1 || x_target > @array.count - 1 || y_target < 0 || x_target < 0
    @array[y_target][x_target]
  end).flatten.compact.inject(:*)
end

def product_of_diagonal_right_up(y, x)
  ([@array[y][x]] + 3.times.map do |time|
    y_target = y - time
    x_target = x + time
    next if y_target > @array.count - 1 || x_target > @array.count - 1 || y_target < 0 || x_target < 0
    @array[y_target][x_target]
  end).flatten.compact.inject(:*)
end

max_result = @array.map.with_index do |row, y|
  row.map.with_index do |cell, x|
    result = products(y, x).max
    puts "#{y}, #{x}: #{result}"
    result
  end.max
end.max

puts "Max Result: #{max_result}"