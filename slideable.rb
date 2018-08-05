require_relative 'board'
require_relative 'null_piece'

module Slideable

  HORIZONTAL_OFFSETS = [
    [0, 1],
    [1, 0],
    [-1, 0],
    [0, -1]
  ]

  DIAGONAL_OFFSETS = [
    [1, 1],
    [1, -1],
    [-1, -1],
    [-1, 1]
  ]

  def moves
    moves = []

    move_dirs.each do |offset_r, offset_c|
      moves.concat(moves_in_one_direction(offset_r, offset_c))
    end

    moves
  end

  def move_dirs

  end

  def moves_in_one_direction(offset_r, offset_c)
    r, c = pos
    moves = []
    while true
      r += offset_r
      c += offset_c
      piece = board[[r, c]]

      return moves unless Board.valid_pos?([r, c])

      if piece.instance_of?(NullPiece)
        moves << [r, c]
      else
        moves << [r, c] if piece.color != color
        return moves
      end
    end
  end

end
