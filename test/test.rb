#!/usr/bin/env ruby


# https://www.2n.pl/blog/basics-of-curses-library-in-ruby-make-awesome-terminal-apps
require 'curses'

include Curses

config = File.read(File.expand_path('~/.ssh/config')).lines
ALIASES = config.grep(/^Host/).map { |line| line.sub(/^Host/, '').strip }.sort

MAX_INDEX = ALIASES.size - 1
MIN_INDEX = 0

@index = 0

init_screen # Initializes a standard screen. At this point the present state of our terminal is saved and the alternate screen buffer is turned on
start_color # Initializes the color attributes for terminals that support it.

init_pair(1, 1, 0)
curs_set(0) # Hides the cursor
noecho # Disables characters typed by the user to be echoed by Curses.getch as they are typed.

begin
  win = Curses::Window.new(0, 0, 1, 2)

  loop do
    win.setpos(0, 0)  # we set the cursor on the starting position

    ALIASES.each.with_index(0) do |str, index|  # we iterate through our data
      if index == @index  # if the element is currently chosen...
        win.attron(color_pair(1)) { win << str }  #...we color it red
      else
        win << str  # rest of the elements are output with a default color
      end
      clrtoeol  # clear to end of line
      win << "\n"  # and move to next
    end
    (win.maxy - win.cury).times { win.deleteln } # clear the rest of the screen
    win.refresh # apply the changes to the screen

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
