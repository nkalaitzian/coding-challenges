file = "3.input.txt"
file_contents = File.open(file, "r").read

class String
  Alpha = ("a".."z").to_a + ("A".."Z").to_a

  def to_i52
    (0..length - 1).map do |i|
      if Alpha.include?(self[i])
        Alpha.index(self[i]) + 1
      end
    end.sum
  end
end

runsack_inventories = file_contents.split("\n").
  map do |runsack|
  half_size = runsack.length / 2
  [runsack[0..half_size - 1], runsack[half_size..-1]]
end

runsack_mistakes = runsack_inventories.map.with_index(1) do |runsack, i|
  inv_1 = runsack.first.split("")
  inv_2 = runsack.last.split("")
  same_item = inv_1.select { |inv_item| true if inv_2.include?(inv_item) }.first
  if same_item.nil?
    # puts "Did not find an item for runsack #{i} - #{runsack.join(", ")}"
    0
  else
    # puts "Found same item '#{same_item}' in runsack #{i} - #{runsack.join(", ")} with priority: #{same_item.to_i52}"
    same_item.to_i52
  end
end

puts "Found a total of Runsack Mistakes #{runsack_mistakes.sum}"

# =============================== 2 ===============================

runsacks = file_contents.split("\n")
grouped_ransacks = (0..runsacks.length - 1).map do |i|
  next if i % 3 != 0
  runsacks[i..i + 2]
end.compact
summed_badges = grouped_ransacks.map.with_index(1) do |grouped_ransack, i|
  common_char = grouped_ransack.first.split("").select do |char|
    grouped_ransack[1].include?(char) && grouped_ransack[2].include?(char)
  end.first
  if common_char.nil?
    # puts "Did not find an item for grouped ransack #{i} - #{grouped_ransack.join(", ")}"
    0
  else
    # puts "Found same item '#{common_char}' in runsack #{i} - #{grouped_ransack.join(", ")} with priority: #{common_char.to_i52}"
    common_char.to_i52
  end
end

puts "Found a total of different badges: #{summed_badges.sum}"
