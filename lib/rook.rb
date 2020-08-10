require './lib/pawn.rb'
require './lib/common_methods.rb'
class Rook < Pawn
  include CommonMethods

  def move(board, finish, available_moves = legal_moves(board, finish))
    super
  end

  def is_legal?(board, finish, legal = legal_moves(board, finish))
    super
  end

  private
  
  def legal_moves(board, finish)
    difference = position - finish
    if difference.length > 1
      {moves: []} # returns if chosen position is illegal
    elsif difference[0].is_a? Integer
      search_moves(board, 1) # direction 1 means vertical moves
    elsif difference[0].is_a? String 
      search_moves(board, 0) # direction 0 means horizontal moves
    end
  end

end
