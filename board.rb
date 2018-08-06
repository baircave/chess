require 'byebug'
require_relative './pieces/king'
require_relative './pieces/queen'
require_relative './pieces/null_piece'
require_relative './pieces/rook'
require_relative './pieces/bishop'
require_relative './pieces/knight'
require_relative './pieces/pawn'

OPP_COLOR = {
  white: :black,
  black: :white
}

class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @previous_move = nil
    @previous_piece = nil
    populate_board
  end

  attr_reader :grid
  attr_accessor :previous_move, :previous_piece

  def []=(pos, piece)
    grid[pos[0]][pos[1]] = piece
  end

  def [](pos)
    grid[pos[0]][pos[1]]
  end

  def populate_board
    init = default_rows

    grid.each_with_index do |row, row_idx|
      grid[row_idx] = init[0] if row_idx == 0
      grid[row_idx] = init[1] if row_idx == 1
      grid[row_idx] = init[4].dup if row_idx.between?(2, 5)
      grid[row_idx] = init[2] if row_idx == 6
      grid[row_idx] = init[3] if row_idx == 7
    end
  end

  def move_piece(color, start_pos, end_pos)
    piece = self[start_pos]
    raise "Can't move nil" if piece.instance_of?(NullPiece)
    raise "Can't move the other player's pieces" if color != piece.color
    raise "Can't move into check!" if move_into_check?(start_pos, end_pos)
    if piece.valid_moves.include?(end_pos)
      move_piece!(start_pos, end_pos)
    else
      raise "Can't move that piece there."
    end
  end

  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]
    self.previous_move = [start_pos, end_pos]
    self.previous_piece = self[end_pos]
    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = NullPiece.instance
  end

  def in_check?(color)
    king_pos = nil
    grid.each do |row|
      row.each do |piece|
        if piece.color == color && piece.is_a?(King)
          king_pos = piece.pos
          break
        end
      end
    end

    return all_moves(OPP_COLOR[color]).include?(king_pos)
  end

  def checkmate?(color)
    numMoves = 0
    return false unless in_check?(color)
    grid.each do |row|
      row.each do |piece|
        if piece.color == color
          moves = piece.moves
          moves.each do |move|
            move_piece!(piece.pos, move)
            numMoves += 1 unless in_check?(color)
            undo
          end
        end
      end
    end

    numMoves.zero?
  end

  def move_into_check?(start_pos, end_pos)
    output = false

    color = self[start_pos].color
    move_piece!(start_pos, end_pos)
    output = true if in_check?(color)
    undo

    output
  end

  def undo
    piece = self[previous_move[1]]
    piece.pos = previous_move[0]
    self[previous_move[0]] = piece
    self[previous_move[1]] = previous_piece
  end

  def all_moves(color)
    moves = []
    grid.each do |row|
      row.each do |piece|
        next unless piece.color == color
        moves.concat(piece.moves)
      end
    end

    moves
  end

  def self.valid_pos?(pos)
    pos[0].between?(0, 7) && pos[1].between?(0, 7)
  end

  def default_rows
    black_row1 = [
      Rook.new([0, 0], self, :black),
      Knight.new([0, 1], self, :black),
      Bishop.new([0, 2], self, :black),
      King.new([0, 3], self, :black),
      Queen.new([0, 4], self, :black),
      Bishop.new([0, 5], self, :black),
      Knight.new([0, 6], self, :black),
      Rook.new([0, 7], self, :black)
    ]
    black_row2 = Array.new(8)
    black_row2.each_index do |i|
      black_row2[i] = Pawn.new([1, i], self, :black)
    end
    white_row1 = Array.new(8)
    white_row1.each_index do |i|
      white_row1[i] = Pawn.new([6, i], self, :white)
    end
    white_row2 = [
      Rook.new([7, 0], self, :white),
      Knight.new([7, 1], self, :white),
      Bishop.new([7, 2], self, :white),
      King.new([7, 3], self, :white),
      Queen.new([7, 4], self, :white),
      Bishop.new([7, 5], self, :white),
      Knight.new([7, 6], self, :white),
      Rook.new([7, 7], self, :white)
    ]
    null_row = Array.new(8) { NullPiece.instance }
    return [black_row1, black_row2, white_row1, white_row2, null_row]
  end

end
