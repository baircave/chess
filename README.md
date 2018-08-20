# Chess

## Summary/Instructions
This implementation of chess was made in Ruby and was designed to be played by two human players in the terminal. Assuming you have Ruby and Homebrew installed on your computer, then simply download the files in this repository, navigate to that directory in your terminal, run `bundle install`, and then run `ruby game.rb` to play. To exit the program, use `CTRL+c`. To select pieces to move, navigate using the arrow keys, use either enter or space to select, and confirm a new space by pressing enter/space again.

## Inheritance/Modules
Chess is a game in which all pieces share certain similarities but not others. Though this is fairly obvious, it's an important consideration to make when creating a class inheritance structure for pieces that keeps the code as DRY as possible. The `piece` superclass gives us a blueprint for commonalities such as piece color, its symbol, and a reference to the board. It also defines a `move` method to be overwritten by its subclasses. While all pieces can move around the board and take enemy pieces, they do so in very different ways. For this reason I created `stepable` and `slideable` modules which allow me to reuse code that is shared between rooks, queens, bishops, kings, and knights. For `slideable` pieces, the rook, queen, and bishop subclasses need only define the directions in which they can possibly slide. For `stepable` pieces, the king and knight subclasses simply define the positions to which they can possibly step. From there, the respective modules handle all of the logic for returning a piece's possible moves from a given board state.

```ruby
#from Slideable module:
def moves
  moves = []

  move_dirs.each do |offset_r, offset_c|
    moves.concat(moves_in_one_direction(offset_r, offset_c))
  end

  moves
end

def moves_in_one_direction(offset_r, offset_c)
  r, c = pos
  moves = []
  while true
    r += offset_r
    c += offset_c
    return moves unless Board.valid_pos?([r, c])

    piece = board[[r, c]]


    if piece.instance_of?(NullPiece)
      moves << [r, c]
    else
      moves << [r, c] if piece.color != color
      return moves
    end
  end
end
```

## Check/Checkmate
In the interest of keeping piece logic decoupled from board/game logic, the `board` class handles logic regarding informing players whether or not they are in check or checkmate. When a player attempts to move a piece, an error is raised if they try to move a piece that is not theirs or if they try to make a move that would put them in check. Logic for the latter is achieved through a method `move_into_check?` which returns a boolean value indicating whether or not a particular move would put them in check. This method actually makes the move, checks to see if any enemy piece can take over the current player's king position, and then undoes the move. If a move does indeed put the current player in check, it is filtered in the piece's `valid_moves` method.

```ruby
#from the Piece superclass:
def valid_moves
  moves.reject { |end_pos| board.move_into_check?(pos, end_pos)}
end

#from the Board class:
def move_into_check?(start_pos, end_pos)
  output = false

  color = self[start_pos].color
  move_piece!(start_pos, end_pos)
  output = true if in_check?(color)
  undo

  output
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
```

## Gameplay/UI
Since this version of chess is currently designed to be played by two human players on one machine, the `current_player` is simply represented by two symbols: `:black` and `:white`. The UI uses minimal Unicode chess pieces with a cursor that is controlled via the arrow, space, and enter keys. The colorize gem differentiates the game pieces and creates the checkered pattern. The game will simply alternate back and forth between black and white until the game ends (when one color is in checkmate) or until it sees `CTRL+c`.

## Upcoming Features
* Castling
* En Passant
* Basic AI Player
