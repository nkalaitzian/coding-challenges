# input = %w[1abc2 pqr3stu8vwx a1b2c3d4e5f treb7uchet];
file_contents = File.open('day_1.txt', 'r').read
input = file_contents.split("\n").map { |ei| ei.split("\n") }.reject { |str| str == "" }.flatten
nums = input.map { |i| i.gsub(/[a-z]/, '') }.map { |i| (i[0] + i[-1]).to_i };
result = nums.sum
puts "Result is: #{result}"

# Part 2

def number_translate(str)
  result = str
  new_result = ""
  while true do
    new_result = result.gsub(/(one|two|three|four|five|six|seven|eight|nine)/,
      "one" => 'o1e', "two" => 't2o', "three" => 't3e', "four" => 'f4r', "five" => 'f5e',
      "six" => 's6x', "seven" => 's7n', "eight" => 'e8t', "nine" => 'n9e')
    if new_result != result
      result = new_result
    else
      break
    end
  end
  result
end

def two_first_digits(i)
  return (i+i).to_i if i.to_i < 10
  # return (i+"0").to_i if i.to_i < 10

  (i[0] + i[-1]).to_i
end
# input = %w[two1nine eightwothree abcone2threexyz xtwone3four 4nineeightseven2 zoneight234 7pqrstsixteen];
nums_2 = input.
  map { |i| number_translate(i) }.
  map { |i| i.gsub(/[a-z]/, '') }.
  map { |i| two_first_digits(i) };
input.each.with_index do |i, x|
  puts "Input: #{i} translates to #{nums_2[x]}"
end
result_2 = nums_2.sum
puts "Second result is: #{result_2}"
