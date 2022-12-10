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

[20, 60, 100, 140, 180, 220].map do |cycle|
  cpu.register_at_cycle(cycle) * cycle
end.sum
# => 14860

[40, 80, 120, 160, 200, 240]
