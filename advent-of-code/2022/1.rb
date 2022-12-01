file_contents = File.open('1.input.txt', 'r').read
elves_inventory = file_contents.split("\n\n").map { |ei| ei.split("\n") }
sorted_elves = elves_inventory.map.with_index do |inv, i|
  calories = inv.map(&:to_i).sum
  # puts "Elf #{i} has #{calories} calories"
  [calories, i]
end.sort_by { |calories, index| calories }.reverse

max_calories, max_elf_index = sorted_elves.max

puts "Max elf: #{max_elf_index}. Max calories: #{max_calories}"

total_calories = sorted_elves.first(3).sum { |elf| elf.first }
sorted_elves.first(3).each.with_index(1) do |elf, i|
  calories, index = elf.first, elf.last
  puts "Elf #{i} - Calories: #{calories}, Index: #{index}"
end;
puts "Total calories by the top 3 elves: #{total_calories}"
