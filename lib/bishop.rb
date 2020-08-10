require './lib/pawn.rb'
require './lib/common_methods.rb'
class Bishop < Pawn
  include CommonMethods

  def move(board, finish, available_moves = legal_moves(board))
    super
  end

  def is_legal?(board, finish, legal = legal_moves(board))
    super
  end

  private

  def legal_moves(board)
      return_hash = {moves: []}
       return_hash[:moves].concat check_diagonal(board, -1, -1, position)
       return_hash[:moves].concat check_diagonal(board, 1, 1, position)
       return_hash[:moves].concat check_diagonal(board, 1, -1, position)
       return_hash[:moves].concat check_diagonal(board, -1, 1, position)
    return_hash
  end

end
