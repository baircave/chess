require 'colorize'
require_relative 'cursor'
require_relative 'board'

BG_COLORS = {
  true => :blue,
  false => :light_black
}

class Display

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  attr_reader :cursor, :board

  def render
    system "clear"
    bg_color_key = true

    board.grid.each_with_index do |row, i|
      bg_color_key = !bg_color_key

      pieces_in_row = []
      row.each do |piece|
        pieces_in_row << piece.to_s
      end

      pieces_in_row.each_with_index do |piece_str, j|
        color = board[[i, j]].color
        if cursor.cursor_pos == [i, j]
          if cursor.selected
            color = :magenta
          else
            color = :green
          end
        end
        if piece_str == "   " && cursor.cursor_pos == [i, j]
          print piece_str.colorize(background: :green)
        else
          print piece_str.colorize(color: color, background: BG_COLORS[bg_color_key])
        end
        bg_color_key = !bg_color_key
      end
      puts "\n"
    end
  end


  def input_loop
    start_pos = nil
    while true #until game over, really
      render
      cursor_output = cursor.get_input
      if cursor_output.is_a?(Array) #this means we've selected a piece
        if start_pos
          board.move_piece(start_pos, cursor_output.dup)
          start_pos = nil
        elsif board[cursor_output].color != nil #it's a non-null piece
          start_pos = cursor_output.dup
        end
      end
    end
  end



end

b = Board.new
d = Display.new(b)
# d.render

d.input_loop
