require './lib/player'
class ChessBoard
attr_accessor :board
  def initialize
    @board = (Array(1..8)).product Array("a".."h")
  end

  def assign_board_squares(player)
    @board.map! do |square|
      find_player_pieces(square, player.pieces)
    end
  end

  def to_s # this probably can be abbreviated with recursion 
    puts "1 - #{square_to_icon(@board[0..7])}"
    puts "    -----------------------------"
    puts "2 - #{square_to_icon(@board[8..15])}"
    puts "    -----------------------------"
    puts "3 - #{square_to_icon(@board[16..23])}"
    puts "    -----------------------------"
    puts "4 - #{square_to_icon(@board[24..31])}"
    puts "    -----------------------------"
    puts "5 - #{square_to_icon(@board[32..39])}"
    puts "    -----------------------------"
    puts "6 - #{square_to_icon(@board[40..47])}"
    puts "    -----------------------------"
    puts "7 - #{square_to_icon(@board[48..55])}"
    puts "    -----------------------------"
    puts "8 - #{square_to_icon(@board[56..63])}"
    puts "    |   |   |   |   |   |   |   |"
         "    a   b   c   d   e   f   g   h"
  end

  private

  def find_player_pieces(board_square, player_array)
    return board_square if player_array.length == 0
    piece = player_array[0]
    return piece if board_square == piece.position
    find_player_pieces(board_square, player_array[1..-1])
  end

  def square_to_icon(array)
    converted = array.map do |element|
      element.class == Array ? element = " " : element = element.icon
    end
    converted_string = ""
    8.times { |x| converted_string << "#{converted[x]} | " }
    converted_string[0..-3]
  end
end


plr1 = Player.new("wał", "black")
chess = ChessBoard.new
plr2 = Player.new("Taco hemingway", "white")
chess.assign_board_squares(plr1)
chess.assign_board_squares(plr2)
puts chess