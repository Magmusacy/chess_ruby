require './lib/pawn.rb'
require './lib/common_methods.rb'
class Queen < Pawn
  include CommonMethods

  def move(board, finish, available_moves = legal_moves(board, finish))
    p available_moves
    super
  end

  def is_legal?(board, finish, legal = legal_moves(board, finish))
    super
  end

  private

  def legal_moves(board, finish)
    difference = position - finish
    if difference.length > 1
      legal_moves_diagonal(board) # if chosen move is diagonal
    elsif difference[0].is_a? Integer
      search_moves(board, 1) # direction 1 means vertical moves
    elsif difference[0].is_a? String 
      search_moves(board, 0) # direction 0 means horizontal moves
    end
  end

  def legal_moves_diagonal(board)
    return_hash = {moves: []}
     return_hash[:moves].concat check_diagonal(board, -1, -1, position)
     return_hash[:moves].concat check_diagonal(board, 1, 1, position)
     return_hash[:moves].concat check_diagonal(board, 1, -1, position)
     return_hash[:moves].concat check_diagonal(board, -1, 1, position)
  return_hash
end

end

