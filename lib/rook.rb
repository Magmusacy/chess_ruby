require './lib/pawn.rb'
require './lib/common_methods.rb'
class Rook < Pawn
  include CommonMethods
  
  def legal_moves(board)
    vertical = search_moves(board, 1) # direction 1 means vertical moves
    horizontal = search_moves(board, 0) # direction 0 means horizontal moves
    hash = {}
    hash[:moves] = vertical[:moves].concat(horizontal[:moves])
    hash
  end

end
