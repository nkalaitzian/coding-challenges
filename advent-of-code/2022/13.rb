require 'json'

def array1_vs_array2(arr1, arr2)
  (0..[arr1.size, arr2.size].max - 1).each do |i|
    elem1 = arr1[i]
    elem2 = arr2[i]

    return true if elem1.nil? && !elem2.nil?
    return false if !elem1.nil? && elem2.nil?

    if elem1.is_a?(Integer) && elem2.is_a?(Integer)
      return true if elem1 < elem2
      return false if elem1 > elem2
    end

    result = array1_vs_array2(elem1, [elem2]) if elem1.is_a?(Array) && elem2.is_a?(Integer)
    result = array1_vs_array2([elem1], elem2) if elem1.is_a?(Integer) && elem2.is_a?(Array)
    result = array1_vs_array2(elem1, elem2) if elem1.is_a?(Array) && elem2.is_a?(Array)
    return result unless result.nil?
  end
  nil
end

signal = if ARGV.empty?
           DATA.read.split("\n\n")
         elsif ARGV[0] == 'input'
           File.read('13.input.txt', chomp: true).split("\n\n")
         end

inputs_in_right_order = signal.map.with_index(1) do |packet_pair, i|
  p1, p2 = packet_pair.split("\n").map { |packet| JSON.parse packet }
  # print "[#{i}]"
  # print " - Comparing P1: #{p1} with P2: #{p2}" if false
  # if p1.levels > p2.levels
  #   puts " Packet 1 has more levels (#{p1.levels}) than Packet 2 (#{p2.levels})"
  #   next
  # end
  # is_array1_smaller_than_array2(p1, p2, print: i == 8)
  if array1_vs_array2(p1, p2)
    puts i
    i
  else
    # puts ' Inputs are not in the right order'
    0
  end
end.sum

puts "Total inputs in right order: #{inputs_in_right_order}"
# Total inputs in right order: 74 # not right
# Total inputs in right order: 6020 # too high
# Total inputs in right order: 5580
divider_packets = [[[2]], [[6]]]
all_packets = []
signal.each { |packet_pair| packet_pair.split("\n").each { |packet| all_packets << (JSON.parse packet) } }
all_packets << divider_packets.first
all_packets << divider_packets.last

all_packets = all_packets.sort do |p1, p2|
  result = array1_vs_array2(p1, p2)
  if result.nil?
    0
  elsif result
    -1
  else
    1
  end
end
all_packets.each { |packet| p packet }
key_1 = all_packets.index(divider_packets.first) + 1
key_2 = all_packets.index(divider_packets.last) + 1
puts "Key1: #{key_1}, Key2: #{key_2}"
decoder_key = key_1 * key_2
puts "Decoder Key: #{decoder_key}"
__END__
[1, 1, 3, 1, 1]
[1, 1, 5, 1, 1]

[[1], [2, 3, 4]]
[[1], 4]

[9]
[[8, 7, 6]]

[[4, 4], 4, 4]
[[4, 4], 4, 4, 4]

[7, 7, 7, 7]
[7, 7, 7]

[]
[3]

[[[]]]
[[]]

[1, [2, [3, [4, [5, 6, 7]]]], 8, 9]
[1, [2, [3, [4, [5, 6, 0]]]], 8, 9]
