require './lib/piece.rb'
class Bishop < Piece
  include CommonMethods

  def legal_moves(board)
      return_hash = {moves: []}
       return_hash[:moves].concat check_diagonal(board, -1, -1, position)
       return_hash[:moves].concat check_diagonal(board, 1, 1, position)
       return_hash[:moves].concat check_diagonal(board, 1, -1, position)
       return_hash[:moves].concat check_diagonal(board, -1, 1, position)
    return_hash
  end

end
