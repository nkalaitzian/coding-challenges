file_name = '6.input.txt'
file = File.expand_path(file_name)
file_contents = File.open(file, 'r').read.lines.first
chars = file_contents.split("")

start_of_packet_marker = []
chars.each.with_index(0) do |s, i|
  start_of_packet_marker.unshift(s)
  if start_of_packet_marker.size == 4 && start_of_packet_marker.uniq.size == 4
    puts "Found start_of_packet_marker index: #{i+1} - marker: #{start_of_packet_marker.join}"
  elsif start_of_packet_marker.size == 4
    start_of_packet_marker.pop
  end
end; nil

# ================ 2

start_of_message_marker = []
chars.each.with_index(0) do |s, i|
  start_of_message_marker.unshift(s)
  if start_of_message_marker.size == 14 && start_of_message_marker.uniq.size == 14
    puts "Found start_of_message_marker index: #{i+1} - marker: #{start_of_message_marker.join}"
  elsif start_of_message_marker.size == 14
    start_of_message_marker.pop
  end
end; nil