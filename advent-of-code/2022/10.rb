# frozen_string_literal: true

file_name = '10.input.txt'
file = File.expand_path(file_name)
file_contents = File.read(file).split("\n")

class CPU
  attr_accessor :cycle, :register, :history

  def initialize
    @cycle = 1
    @register = 1
    @history = []
    record_history
  end

  def noop
    @cycle += 1
    record_history
  end

  def addx(val)
    @cycle += 1
    record_history
    @cycle += 1
    @register += val.to_i
    record_history
  end

  def to_s
    "cycle: #{@cycle}, register: #{@register}"
  end

  def register_at_cycle(cycle)
    @history.each do |hist|
      return hist[:register] if hist[:cycle] == cycle
    end
    nil
  end

  def pixel_at(cycle, column)
    case register_at_cycle(cycle)
    when (column - 1)..(column + 1)
      '#'
    else
      '.'
    end
  end

  private

  def record_history
    @history += [{ cycle: @cycle, register: @register }]
  end
end

instructions = file_contents
cpu = CPU.new
instructions.each do |i|
  case i
  when 'noop'
    cpu.noop
  when /addx\s(-)?(\d)+/
    cpu.addx(i.gsub('addx ', ''))
  end
end

# [20, 60, 100, 140, 180, 220].map do |cycle|
#   cpu.register_at_cycle(cycle) * cycle
# end.sum
# => 14860

crt_lines = [(1..40).to_a, (41..80).to_a, (81..120).to_a, (121..160).to_a, (161..200).to_a, (201..240).to_a]
crt_lines.each do |row|
  line = '###.....................................'.chars
  row.each.with_index(1) do |pixel, column|
    line[column - 1] = cpu.pixel_at(pixel, column - 1)
  end
  puts line.join
end; nil

###...##..####.####.#..#.#..#.###..#..#.
#..#.#..#....#.#....#..#.#..#.#..#.#.#..
#..#.#......#..###..####.#..#.#..#.##...
###..#.##..#...#....#..#.#..#.###..#.#..
#.#..#..#.#....#....#..#.#..#.#.#..#.#..
#..#..###.####.####.#..#..##..#..#.#..#.