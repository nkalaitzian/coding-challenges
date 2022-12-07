# frozen_string_literal: true

file_name = '7.input.txt'
file = File.expand_path(file_name)
file_contents = File.read(file).lines.map { |l| l.gsub("\n", '') }

class FileStructure
  ROOT = '/'
  TYPES = [:file, :folder].freeze
  MIN_FOLDER_THRESHOLD = 100_000.freeze
  MAX_SPACE_THRESHOLD = 40_000_000.freeze

  attr_reader :name, :size, :type
  attr_accessor :children, :parent_dir, :level

  def self.root
    $root ||= new('/', :folder, size: 0)
  end

  def tree
    puts "#{' ' * level}- (#{type == :folder ? 'd' : 'f'}) #{name} (#{total_size})"
    children.each(&:tree) if type == :folder

    nil
  end

  def points_of_interest
    results = []

    results << self.total_size if total_size < MIN_FOLDER_THRESHOLD && type == :folder
    results += children.map(&:points_of_interest).flatten if type == :folder

    results
  end

  def total_size
    if type == :file
      size
    else
      calculate_folder_size
    end
  end

  def initialize(name, type, size: 0, level: 0)
    return if name == '/' && $root

    @type = type.to_sym
    @name = name
    @size = if type == :file
              size.to_i
            else
              0
            end
    @children = []
    @level = level
  end

  def cd(target)
    if target == '..'
      go_up
    else
      go_in(target)
    end
  end

  def add_child(child)
    return false if type == :file

    if @children.select { |c| c.name == child.name && c.type == child.type }.any?
      raise "Cannot create child #{child.name}. Structure already exists"
    end

    @children += [child]
    child.parent_dir = self
    child.level = level + 1
    true
  end

  def total_size_after_cleanup
    $root.total_size - total_size
  end

  def will_cleanup_be_enough?
    total_size_after_cleanup < MAX_SPACE_THRESHOLD && type == :folder
  end

  def cleanup_space
    candidates = []
    candidates << self if will_cleanup_be_enough?
    candidates += children.map(&:cleanup_space).flatten.compact.select(&:will_cleanup_be_enough?)

    candidates.min_by(&:total_size)
  end

  private

  def go_up
    parent_dir
  end

  def go_in(target)
    raise "Could not find child dir '#{target}'" unless children.map(&:name).include?(target)

    # self
    children.select { |c| c.name == target }.first
  end

  def calculate_folder_size
    return 0 unless type == :folder
    return 0 if type == :folder && children.empty?

    children.map(&:total_size).sum
  end
end

root = FileStructure.root
current_dir = root
file_contents[1..].each do |fc|
  case fc
  when /\$ cd /
    current_dir = current_dir.cd(fc.gsub('$ cd ', '').gsub(' ', ''))
  when /\$ ls /
    next
  when /(\d)+ /
    size = fc.split.first
    name = fc.split.last
    f = FileStructure.new(name, :file, size: size)
    current_dir.add_child(f)
  when /dir /
    dir_name = fc.split.last
    dir = FileStructure.new(dir_name, :folder, size: 0)
    current_dir.add_child(dir)
  end
end

# root.tree
root.points_of_interest.sum
# 5724164 too high
# 1555642 just right
candidate = root.cleanup_space.total_size
# 5974547