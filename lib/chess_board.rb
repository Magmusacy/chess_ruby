require './lib/player'
class ChessBoard
attr_accessor :board
  def initialize 
    @board = ((Array(1..8)).product Array("a".."h")).sort_by { |x,y| -x }
  end

  def assign_board_squares(player)
    @board.map! do |square|
      find_player_pieces(square, player.pieces)
    end
  end

  def to_s(array=@board, i=8)
    return puts "    ⬆   ⬆   ⬆   ⬆   ⬆   ⬆   ⬆   ⬆" if i == 0
    puts "#{i} ➡ #{square_to_icon(array[0..7])}"
    puts "    ━━┼━━━┼━━━┼━━━┼━━━┼━━━┼━━━┼━━━" unless i == 1
    to_s(array[8..-1], i-1)
         "    a   b   c   d   e   f   g   h"
  end

  private

  def find_player_pieces(board_square, player_array)
    return board_square if player_array.empty?
    piece = player_array[0]
    return piece if board_square == piece.position
    find_player_pieces(board_square, player_array[1..-1])
  end

  def square_to_icon(array)
    converted = array.map do |element|
      element.is_a?(Array) ? element = " " : element = element.icon
    end
    converted_string = ""
    8.times { |x| converted_string << "#{converted[x]} ┃ " }
    converted_string[0..-3]
  end
end

