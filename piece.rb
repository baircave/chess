require_relative 'board'

class Piece

  def initialize(current_pos, board, color)
    @current_pos = current_pos
    @board = board
    @color = color
  end

end
