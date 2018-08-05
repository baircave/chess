require_relative 'piece'
require_relative 'slideable'

class Queen < Piece
  include Slideable

  def symbol
    "♛"
  end

  def move_dirs
    HORIZONTAL_OFFSETS + DIAGONAL_OFFSETS
  end

end
