require_relative 'piece'
require_relative 'slideable'

class Bishop < Piece
  include Slideable

  def symbol
    "♝"
  end

  def move_dirs
    DIAGONAL_OFFSETS
  end

end
