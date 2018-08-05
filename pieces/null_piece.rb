require 'singleton'
require_relative 'piece'

class NullPiece < Piece
  include Singleton

  def initialize
    @symbol = " "
    @color = nil
  end

  def symbol
    @symbol
  end

end
