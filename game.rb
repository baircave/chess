require_relative 'board'
require_relative 'display'

class Game

  attr_reader :board, :display
  attr_accessor :current_player

  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @current_player = :white
  end


  def play
    start_pos = nil

    until game_over?
      display.render
      puts "#{current_player.to_s.capitalize}'s turn to move"
      puts "You're in check!" if board.in_check?(current_player)

      begin
        cursor_output = display.cursor.get_input
        if cursor_output.is_a?(Array) #this means we've selected a piece
          if start_pos
            board.move_piece(current_player, start_pos, cursor_output.dup)
            start_pos = nil
            switch_current_player
          elsif board[cursor_output].color != nil #it's a non-null piece
            start_pos = cursor_output.dup
          end
        end
      rescue => error
        puts error.message
        start_pos = nil
        retry
      end
    end

    display.render
    puts "Checkmate, white wins!" if board.checkmate?(:black)
    puts "Checkmate, black wins!" if board.checkmate?(:white)
  end

  def switch_current_player
    self.current_player = current_player == :white ? :black : :white
  end

  def game_over?
    board.checkmate?(:white) || board.checkmate?(:black)
  end

end

g = Game.new
g.play
