input = %w[467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..];
file_contents = File.open('day_3.txt', 'r').read
input = file_contents.split("\n").map { |ei| ei.split("\n") }.reject { |str| str == "" }.flatten

@input_arr = input.map do |line, y|
  line.split('')
end;

def is_part_number?(y, x)
  up_lim = (y - 1 >= 0) ? y - 1 : y
  left_lim = (x - 1 >= 0) ? x - 1 : x
  neighbors = @input_arr[up_lim..y+1].map { |line| line[left_lim..x+1] }.flatten
  neighbors.any? { |n| !n.to_s.match?(/(\d|\.)/) }
end

def get_part_number(y, x)
  raise 'lalala' unless is_part_number?(y, x)
  # puts "Getting part number. Y: #{y}, X: #{x}"
  line = @input_arr[y]
  part_number = line[x]
  left, left_id = [x, x]
  right, right_id = [x, x]
  while left != nil || right != nil
    left_id -= 1 unless left == nil
    right_id += 1 unless right == nil
    if left_id >= 0
      left = line[left_id]
    else
      left = nil
    end
    if right_id < line.size
      right = line[right_id]
    else
      right = nil
    end
    left = nil if left.to_s.match?(/\D/)
    right = nil if right.to_s.match?(/\D/)
    part_number = "#{left}#{part_number}" if left != nil
    part_number = "#{part_number}#{right}" if right != nil
  end
  part_number
rescue
  "-1"
end

part_numbers = [];
@input_arr.each.with_index do |line, y|
  line_part_numbers = []
  line.each.with_index do |cell, x|
    # puts "Cell: #{cell}, y: #{y}, x: #{x}"
    next unless cell.match?(/\d/)

    if is_part_number?(y, x)
      part_number = get_part_number(y, x)
      line_part_numbers << part_number unless get_part_number(y, x+1) == part_number
    end
  end
  part_numbers += line_part_numbers
  puts "Found part numbers for line #{y}: #{line_part_numbers}"
end

sum = part_numbers.map(&:to_i).inject(:+)
puts "Sum of part numbers: #{sum}"
