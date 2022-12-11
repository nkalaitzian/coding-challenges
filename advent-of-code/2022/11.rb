class Monkey
  @all_monkeys = []
  @round = 0

  attr_reader :idx, :starting_items, :operation, :test, :true_conditions, :false_conditions
  attr_accessor :items, :total_inspections

  def self.build
    @all_monkeys = []
    @round = 0
    @tests_lcm = nil
    file_name = '11.input.txt'
    # file_name = '11.test.txt'
    file = File.expand_path(file_name)
    monkeys = File.read(file).split("\n\n")
    monkeys.each do |monkey|
      idx_line, items_line, operation_line, test_line, if_true_line, if_false_line = monkey.split("\n")
      idx = idx_line.gsub('Monkey ', '').gsub(':', '')
      items = items_line.gsub('  Starting items: ', '')
      operation = operation_line.gsub('  Operation: ', '')
      test = test_line.gsub('  Test: ', '')
      if_true = if_true_line.gsub('    If true: ', '')
      if_false = if_false_line.gsub('    If false: ', '')
      Monkey.new(idx, items, operation, test, if_true, if_false)
    end
    nil
  end

  def self.find_monkey_by_index(idx, print: true)
    puts "    Attempting to find monkey #{idx}" if print
    @all_monkeys.select { |monkey| monkey.idx == idx }.first
  end

  def self.round(idx, downgrade: true, print: true)
    @round = idx
    puts "\nStarting round #{idx} - Downgrade: #{downgrade}" if print
    @all_monkeys.each { |monkey| monkey.inspect_items(downgrade: downgrade, print: print) }
    puts "Round #{idx} complete!\n" if print
  end

  class << self
    attr_reader :all_monkeys
  end

  def self.top_inspectors
    @all_monkeys.sort_by(&:total_inspections).reverse.first(2).map(&:total_inspections).inject(:*)
  end

  def self.tests_lcm
    @tests_lcm ||= @all_monkeys.map(&:test).inject(:lcm)
  end

  def initialize(idx, starting_items, operation, test, true_conditions, false_conditions)
    @idx = idx.to_i
    @starting_items = starting_items.split(', ').map(&:to_i)
    operator, number = operation.gsub('new = old ', '').split
    @operation = { operator: operator, number: number }
    @test = test.gsub('divisible by ', '').to_i
    @true_conditions = true_conditions.gsub('throw to monkey ', '').to_i
    @false_conditions = false_conditions.gsub('throw to monkey ', '').to_i
    @items = @starting_items.dup
    @total_inspections = 0
    Monkey.all_monkeys << self
  end

  def inspect_items(downgrade: true, print: true)
    puts "Monkey #{idx} - Inspections: #{total_inspections} - Inspecting items: #{@items}" if print
    items.each do |item|
      inspection = inspect(item, print: print)
      worry_level = if downgrade
                      inspection / 3
                    else
                      inspection % Monkey.tests_lcm
                    end
      puts "  Worry Level #{'after /3' if downgrade} is: #{worry_level}" if print
      test_result = test!(worry_level, print: print)
      target_monkey_id = calculate_conditions(test_result, print: print)

      target_monkey = Monkey.find_monkey_by_index(target_monkey_id, print: print)
      throw_item_to_monkey(item, worry_level, target_monkey, print: print)
    end
    @items = []
    puts if print
  end

  def to_s
    "Monkey #{idx}\n" \
      "  Has items: #{items}\n" \
      "  Operations: #{operation}\n" \
      "  Total inspections: #{total_inspections}\n" \
      "  Thrown to monkeys: if true: #{true_conditions}, if false: #{false_conditions}\n"
  end

  private

  def operator
    @operation[:operator]
  end

  def number
    @operation[:number]
  end

  def inspect(item, print: true)
    item = item.to_i
    raise "Could not find item #{item}. Items: #{items}" unless items.include?(item)

    puts "  inspects an item with a worry level of #{item}" if print
    @total_inspections += 1
    inspection_result = case operator
                        when '+'
                          item + number.to_i
                        when '*'
                          if number == 'old'
                            item * item
                          else
                            item * number.to_i
                          end
                        end
    puts "    New Worry Level: #{inspection_result}" if print
    inspection_result
  end

  def test!(worry_level, print: true)
    print "    Testing Worry Level: #{worry_level}" if print
    test_result = (worry_level % @test).zero?
    puts " - Result: #{'not ' unless test_result}divisible by #{@test}" if print
    test_result
  end

  def calculate_conditions(value, print: true)
    puts '    Calculating monkey id to throw item.' if print
    target_monkey_id = if value
                         @true_conditions
                       else
                         @false_conditions
                       end
    puts "    Found monkey: #{target_monkey_id}" if print
    target_monkey_id
  end

  def throw_item_to_monkey(item, worry_level, monkey, print: true)
    if print
      puts "    Throwing item #{item} with worry level #{worry_level} to Monkey: #{monkey.idx}"
    end
    raise "Could not find item #{item}. Items: #{items}" unless items.include?(item)

    monkey.items << worry_level

    puts '    Success!' if print
  end
end

# puts Monkey.all_monkeys.map(&:to_s)
Monkey.build
rounds = 20
rounds.times.with_index(1) do |_time, idx|
  Monkey.round(idx, downgrade: true, print: false)
  # puts Monkey.all_monkeys.map(&:to_s)
  # puts
end

puts "Top inspector monkeys after #{rounds} rounds: #{Monkey.top_inspectors}"
# => 68
# Top inspector monkeys: 1056
# Top inspector monkeys: 4556 # too low
# Top inspector monkeys after 20 rounds: 99852

# ================================================ 2 =========================================================
Monkey.build
rounds = 10_000
rounds.times.with_index(1) do |_time, idx|
  Monkey.round(idx, downgrade: false, print: false)
  # puts Monkey.all_monkeys.map(&:to_s)
  # if (idx % 1000).zero?
  # puts idx
  # puts Monkey.all_monkeys.map(&:to_s)
  # puts "Top inspector monkeys: #{Monkey.top_inspectors}"
  # end
end
puts "Top inspector monkeys after #{rounds} rounds: #{Monkey.top_inspectors}"
# Top inspector monkeys after 10000 rounds: 25935263541
