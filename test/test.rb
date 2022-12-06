#!/usr/bin/env ruby

require 'curses'

include Curses

config = File.read(File.expand_path('~/.ssh/config')).lines
ALIASES = config.grep(/^Host/).map { |line| line.sub(/^Host/, '').strip }.sort

MAX_INDEX = ALIASES.size - 1
MIN_INDEX = 0

@index = 0

init_screen
start_color

init_pair(1, 1, 0)
curs_set(0)
noecho

begin
  win = Curses::Window.new(0, 0, 1, 2)

  loop do
    win.setpos(0, 0)

    ALIASES.each.with_index(0) do |str, index|
      if index == @index
        win.attron(color_pair(1)) { win << str }
      else
        win << str
      end
      clrtoeol
      win << "\n"
    end
    (win.maxy - win.cury).times { win.deleteln }
    win.refresh

    str = win.getch.to_s
    case str
    when 'j'
      @index = @index >= MAX_INDEX ? MAX_INDEX : @index + 1
    when 'k'
      @index = @index <= MIN_INDEX ? MIN_INDEX : @index - 1
    when '10'
      @selected = ALIASES[@index]
      exit 0
    when 'q' then exit 0
    end
  end
ensure
  close_screen
  exec "ssh #{@selected}" if @selected
end
