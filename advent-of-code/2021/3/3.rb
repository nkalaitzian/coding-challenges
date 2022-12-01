f = File.open('/home/nkalaitzian/Documents/advent-of-code/2021/3/input.txt')
lines = f.readlines.map(&:chomp)
f.close

def calculate_vbits (lines: [])
  vbits = {}
  lines.each do |line|
    line.strip.split('').each.with_index(0) do |c, i|
      unless vbits[i]
        vbits[i] = { c.to_i => 1 }
      else
        if vbits[i][c.to_i]
          vbits[i][c.to_i] += 1
        else
          vbits[i][c.to_i] = 1
        end
      end
    end
  end
  # puts "VBits: #{vbits.inspect}"  
  vbits
end

vbits = calculate_vbits(lines: lines)
puts "VBits: #{vbits.inspect}"

gamma_bin = ""
epsilon_bin = ""
vbits.each do |k,v|
  gamma_bin += v[0] > v[1]? "0" : "1"
  epsilon_bin += v[0] > v[1]? "1" : "0"
end

gamma = gamma_bin.to_i(2)
epsilon = epsilon_bin.to_i(2)
pow = gamma * epsilon
puts "Gamma Binary:#{gamma_bin} - Gamma:#{gamma}"
puts "Epsilon Binary:#{epsilon_bin} - Epsilon:#{epsilon}"
puts "Power Consumption: #{pow}"


og_arr = lines
co_arr = lines
og_vbits = calculate_vbits(lines: og_arr)
co_vbits = calculate_vbits(lines: co_arr)
(0...vbits.size).to_a.each do |l|
  og_vbits = calculate_vbits(lines: og_arr)
  co_vbits = calculate_vbits(lines: co_arr)
  temp_co_arr = []
  temp_og_arr = []
  # puts "OG class: #{og_arr.class} - CO class: #{co_arr.class}"
  # puts "VBITS for position #{l}: 0:#{vbits[l][0]} 1:#{vbits[l][1]}"
  unless og_arr.size == 1
    og_vbits = calculate_vbits(lines: og_arr)
    if og_vbits[l][0] > og_vbits[l][1]
      temp_og_arr = og_arr.select { |og| og.split('')[l] == "0" }
    else
      temp_og_arr = og_arr.select { |og| og.split('')[l] == "1" }
    end
  end
  unless co_arr.size == 1
    co_vbits = calculate_vbits(lines: co_arr)
    if co_vbits[l][0] > co_vbits[l][1]
      temp_co_arr = co_arr.select { |co| co.split('')[l] == "1" }
    else
      temp_co_arr = co_arr.select { |co| co.split('')[l] == "0" }
    end
  end
  # puts "Temp OG class: #{temp_og_arr.class} - Temp CO class: #{temp_co_arr.class}"
  og_arr = temp_og_arr unless temp_og_arr.size == 0
  co_arr = temp_co_arr unless temp_co_arr.size == 0
end

og_binary = og_arr.first
co_binary = co_arr.first
puts "Oxygen Generator Rating Binary:#{og_binary}"
puts "CO2 Scrubber Rating Binary:#{co_binary}"

og = og_binary.to_i(2)
co = co_binary.to_i(2)
life_support_rating = og * co

puts "Oxygen Generator Rating:#{og}"
puts "CO2 Scrubber Rating:#{co}"
puts "Life Support Rating:#{life_support_rating}"