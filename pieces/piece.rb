class Piece

  attr_reader :board, :color
  attr_accessor :pos

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def moves

  end

  def valid_moves
    moves.reject { |end_pos| board.move_into_check?(pos, end_pos)}
  end

  def to_s
    " #{symbol} "
  end

end
