require './lib/pawn.rb'
class Knight < Pawn

  def legal_moves(board, return_hash = {moves: []})
    possible_moves = [
    [position[0] + 2, (position[1].ord + 1).chr],
    [position[0] + 2, (position[1].ord - 1).chr],
    [position[0] - 2, (position[1].ord + 1).chr],
    [position[0] - 2, (position[1].ord - 1).chr],
    [position[0] + 1, (position[1].ord + 2).chr],
    [position[0] + 1, (position[1].ord - 2).chr],
    [position[0] - 1, (position[1].ord + 2).chr],
    [position[0] - 1, (position[1].ord - 2).chr]
    ]
    board.each do |square|
      if square.is_a?(Array) && possible_moves.include?(square)
        return_hash[:moves] << square
      elsif !square.is_a?(Array) && square.color != color && possible_moves.include?(square.position)
        return_hash[:moves] << {square.position => square}
      end
    end
    return_hash
  end
end
