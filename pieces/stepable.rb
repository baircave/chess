require_relative '../board'
require_relative 'null_piece'

module Stepable

  def moves
    moves = []
    possible_steps.each do |offset_r, offset_c|
      move = check_step(offset_r, offset_c)
      moves << move if move
    end

    moves
  end

  def possible_steps

  end

  def check_step(offset_r, offset_c)
    r, c = pos
    r += offset_r
    c += offset_c

    return unless Board.valid_pos?([r, c])

    piece = board[[r, c]]

    if piece.instance_of?(NullPiece) || piece.color != color
      return [r, c]
    end
  end

end
