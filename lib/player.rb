require './lib/pawn.rb'
require './lib/rook.rb'
require './lib/knight.rb'
require './lib/queen.rb'
require './lib/king.rb'
require './lib/bishop.rb'
class Player
attr_reader :name, :pieces
  def initialize(name, color)
    @name = name
    start = color == 'black' ? 1 : 8 # this is the row the player is starting with
    @pieces = create_pieces(start)
  end

  def create_pieces(start)
    initial_letter = "a".ord
    case start # this might be changed in the future but will do for now
    when 1
      pieces = [Rook.new("♜", [1, "a"]), Knight.new("♞", [1, "b"]), Bishop.new("♝", [1, "c"]), Queen.new("♛", [1, "d"]), King.new("♚", [1, "e"]), Bishop.new("♝", [1, "f"]), Knight.new("♞", [1, "g"]), Rook.new("♜", [1, "h"])]
      8.times { |i| pieces << Pawn.new("♟︎", [2, (initial_letter + i).chr])}
    when 8
      pieces = [Rook.new("♖", [8, "a"]), Knight.new("♘", [8, "b"]), Bishop.new("♗", [8, "c"]), Queen.new("♕", [8, "d"]), King.new("♔", [8, "e"]), Bishop.new("♗", [8, "f"]), Knight.new("♘", [8, "g"]), Rook.new("♖", [8, "h"])]
      8.times { |i| pieces << Pawn.new("♙", [7, (initial_letter + i).chr])}
    end
    pieces
  end
end
