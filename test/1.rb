file_path = "/home/nkalaitzian/Documents/code/coding-challenges/test"
file_name = "1.csv"
file_contents = File.open(file_path + file_name, "r").read
lines = file_contents.split("\n")

sum_amounts = 0
lines.each do |line|
  cells = line.split(",")
  coupon_code = cells[0]
  coupon_amount = cells[1]
  coupon_expiration = cells[2]
  sum_amounts += coupon_amount.to_i
  puts "Coupon Code: #{coupon_code}, Amount: #{coupon_amount}, Expiration: #{coupon_expiration}"
end

puts "Summed Amount: #{sum_amounts}"
