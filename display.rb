require 'colorize'
require_relative 'cursor'
require_relative 'piece'

BG_COLORS = {
  true => :black,
  false => :light_black
}

class Display

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
  end

  def render
    system "clear"
    bg_color_key = true

    @cursor.board.grid.each_with_index do |row, i|
      bg_color_key = !bg_color_key

      pieces_in_row = []
      row.each do |piece|
        bg_color_key = !bg_color_key
        if piece.is_a?(Piece)
          pieces_in_row << " P "
        else
          pieces_in_row << " X "
        end
      end

      pieces_in_row.each_with_index do |piece_str, j|
        color = :white
        if @cursor.cursor_pos == [i, j]
          if @cursor.selected
            color = :magenta
          else
            color = :green
          end
        end
        print piece_str.colorize(color: color, background: BG_COLORS[bg_color_key])
        bg_color_key = !bg_color_key
      end
      puts "\n"
    end
  end


  def input_loop
    while true
      render
      @cursor.get_input
    end
  end



end

b = Board.new
d = Display.new(b)
# d.render

d.input_loop
