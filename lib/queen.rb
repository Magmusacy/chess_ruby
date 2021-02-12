require './lib/piece.rb'
class Queen < Piece
  include CommonMethods

  def legal_moves(board)
    vertical = search_moves(board, 1) # direction 1 means vertical moves
    horizontal = search_moves(board, 0) # direction 0 means horizontal moves
    hash = {}
    hash[:moves] = vertical[:moves].concat(horizontal[:moves]).concat(legal_moves_diagonal(board)[:moves])
    hash
  end

  private

  def legal_moves_diagonal(board)
    return_hash = {moves: []}
     return_hash[:moves].concat check_diagonal(board, -1, -1, position)
     return_hash[:moves].concat check_diagonal(board, 1, 1, position)
     return_hash[:moves].concat check_diagonal(board, 1, -1, position)
     return_hash[:moves].concat check_diagonal(board, -1, 1, position)
  return_hash
end

end
