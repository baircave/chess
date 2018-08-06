require_relative 'piece'
require_relative 'stepable'

class King < Piece
  include Stepable

  def symbol
    "♚"
  end

  def possible_steps
    [
      [1, 1],
      [-1, 1],
      [1, -1],
      [-1, -1],
      [0, 1],
      [1, 0],
      [-1, 0],
      [0, -1]
    ]
  end

end
