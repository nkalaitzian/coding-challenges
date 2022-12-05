file = "5.input.txt"
file_contents = File.open(file, "r").read

crates = file_contents.split("\n").first(8).reverse.each.with_object({}) do |line, crates|
  arr = line.split("")
  columns = (0..8).map { |i| arr[1 + i * 4] }
  columns.each.with_index(1) do |c, i|
    crates[i] = [] if crates[i].nil?
    crates[i] << c if c != " "
  end
end

instructions = file_contents.
  split("\n")[10..-1].
  map { |l| l.gsub("move ", "").gsub(" from", "").gsub(" to", "") }.
  map do |instr|
  items = instr.split(" ")[0].to_i
  from = instr.split(" ")[1].to_i
  to = instr.split(" ")[2].to_i
  [items, from, to]
end

instructions.each do |items, from, to|
  puts "Instructions: Move #{items} from #{from} to #{to}"
  items.times { crates[to].push(crates[from].pop) }
end

crates.to_a.each do |k, v|
  print "#{v.last}"
end
puts
# WSFTMRHPP

# =================== 2 ==================

crates_9001 = file_contents.split("\n").first(8).reverse.each.with_object({}) do |line, crates_9001|
  arr = line.split("")
  columns = (0..8).map { |i| arr[1 + i * 4] }
  columns.each.with_index(1) do |c, i|
    crates_9001[i] = [] if crates_9001[i].nil?
    crates_9001[i] << c if c != " "
  end
end

instructions.each do |items, from, to|
  crates_9001[to] += crates_9001[from].pop(items)
end

crates_9001.to_a.each do |k, v|
  print "#{v.last}"
end
puts
# GSLCMFBRP
