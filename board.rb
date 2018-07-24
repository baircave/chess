require 'byebug'
require_relative 'piece'

class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    populate_board
  end

  attr_reader :grid

  def []=(pos, piece)
    grid[pos[0]][pos[1]] = piece
  end

  def [](pos)
    grid[pos[0]][pos[1]]
  end

  def move_piece(start_pos, end_pos)
    raise "Can't move nil" if self[start_pos] == nil
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end


  def populate_board
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |_, col_idx|
        if row_idx < 2 || row_idx > 5
          self[[row_idx, col_idx]] = Piece.new([row_idx, col_idx], self, "black")
        end
      end
    end
  end

end
