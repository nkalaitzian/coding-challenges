f = File.open('/home/nkalaitzian/Documents/advent-of-code/2021/1/input.txt')
lines = f.readlines.map(&:chomp)
f.close

def calculate_increased_values (lines:)
  previous_line = nil
  num=0
  lines.each.with_index(1) do |l, idx|
    # puts "#{idx}/#{lines.size} - #{l}"
    unless previous_line
      previous_line = l
      next
    end
    if l.to_i > previous_line.to_i
      num+=1
    else
      puts "#{idx-1}/#{lines.size} - #{previous_line}"
      puts "#{idx}/#{lines.size} - #{l}"
    end
    previous_line = l
  end;
  puts "Num #{num}"
end
calculate_increased_values(lines: lines)

summed_lines = lines.map.with_index(0) do |l, i| 
  next if i == 0 or i == lines.size-1
  sum = (lines[i-1].to_i + l.to_i + lines[i+1].to_i)
end.compact
calculate_increased_values(lines: summed_lines)