require_relative 'piece'

DIAGONAL_PAWN_OFFSETS = {
  white: [[-1, -1], [-1, 1]],
  black: [[1, 1], [1, -1]]
}

PERP_PAWN_OFFSETS = {
  white: [[-1, 0], [-2, 0]],
  black: [[1, 0], [2, 0]]
}

OG_ROW = {
  white: 6,
  black: 1
}

class Pawn < Piece

  def symbol
    "♟"
  end

  def moves
    moves = []
    DIAGONAL_PAWN_OFFSETS[color].each do |offset_r, offset_c|
      r, c = pos[0] + offset_r, pos[1] + offset_c
      next unless Board.valid_pos?([r, c])
      piece = board[[r, c]]
      if piece.color != color && piece.color != nil
        moves << [r, c]
      end
    end

    one_step = PERP_PAWN_OFFSETS[color][0]
    two_steps = PERP_PAWN_OFFSETS[color][1]
    r1, c1 = pos[0] + one_step[0], pos[1] + one_step[1]
    r2, c2 = pos[0] + two_steps[0], pos[1] + two_steps[1]

    if Board.valid_pos?([r1, c1])
      piece1 = board[[r1, c1]]
      if piece1.instance_of?(NullPiece)
        moves << [r1, c1]
        if pos[0] == OG_ROW[color] && Board.valid_pos?([r2, c2])
          piece2 = board[[r2, c2]]
          moves << [r2, c2] if piece2.instance_of?(NullPiece)
        end
      end
    end

    moves
  end

end
