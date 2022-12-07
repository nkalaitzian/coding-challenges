file_name = '7.input.txt'
file = File.expand_path(file_name)
file_contents = File.open(file, 'r').read.lines.first

class FileStructure
  ROOT = '/'.freeze
  TYPES = [:file, :folder].freeze

  attr_reader :name, :size, :type
  attr_accessor :children, :parent_dir

  def initialize(name, type, size)
    @type = type.to_sym
    @name = name
    if type == :file
      @size = size
    else
      @size = 0
    end
    @children = []

    if name == '/' && !$root.nil?
      raise 'Root already exists.'
    end
  end

  def total_size
    if type == :file
      size
    else
      calculate_folder_size
    end
  end

  def self.root
    $root ||= new('/', :folder, 0)
  end

  def cd(target)
    if target == '..'
      go_up
    else
      go_in(target)
    end
  end

  def add_sub(child)
    if @children.select { |c| c.name == child.name && c.type == child.type }.any?
      raise "Cannot create child #{child.name}. Structure already exists"
    else
      @children << child
      child.parent_dir = self
    end
  end

  def self.file_tree
    
  end

  private

  def go_up
    parent_dir
  end

  def go_in(target)
    if children.map(&:name).include?(target)
      children.select { |c| c.name == target }.first
    else
      raise 'Could not find child dir'
    end
  end

  def calculate_folder_size
    return 0 unless type == :folder
    return 0 if type == :folder && children.empty?

    children.map(&:total_size).sum
  end
end

root = FileStructure.root