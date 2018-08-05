require "io/console"

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board
  attr_accessor :selected, :selected_pos

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
    @selected = false
    @selected_pos = []
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def handle_key(key)
    case key
    when :up, :down, :left, :right
      update_pos(key)
      nil
    when :ctrl_c
      Process.exit(0)
    when :return, :space
      toggle_selected
      cursor_pos
    end
  end

  def update_pos(diff)
    r_offset, c_offset = MOVES[diff][0], MOVES[diff][1]
    new_r = cursor_pos[0] + r_offset
    new_c = cursor_pos[1] + c_offset
    pos = [new_r, new_c]
    if Board.valid_pos?(pos)
      cursor_pos[0] += r_offset
      cursor_pos[1] += c_offset
    end
  end

  def toggle_selected
    if board[cursor_pos].color == nil || self.selected
      self.selected = false
      self.selected_pos = []
    elsif !self.selected
      self.selected = true
      self.selected_pos = self.cursor_pos.dup
    end
  end

end
