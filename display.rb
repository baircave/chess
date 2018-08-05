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

      row.each_with_index do |piece, j|
        bg_color = BG_COLORS[bg_color_key]
        color = board[[i, j]].color
        color = :green if cursor.cursor_pos == [i, j]
        if piece.color == nil && cursor.cursor_pos == [i, j]
          bg_color = :green
        elsif piece.color && cursor.selected_pos == [i, j]
          bg_color = :magenta
        end

        print piece.to_s.colorize(color: color, background: bg_color)
        bg_color_key = !bg_color_key
      end
      puts "\n"
    end
  end


  def input_loop
    start_pos = nil
    until board.checkmate?(:white) || board.checkmate?(:black)
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

    render
    puts "Checkmate, white wins!" if board.checkmate?(:black)
    puts "Checkmate, black wins!" if board.checkmate?(:white)
  end



end

b = Board.new
d = Display.new(b)
# d.render

d.input_loop
