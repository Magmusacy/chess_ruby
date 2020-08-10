require './lib/pawn.rb'
class Bishop < Pawn

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

  def check_diagonal(board, character, number, curr_pos, moves = [])
    return moves if moves.any? { |el| el.is_a?(Hash) }
    next_pos = [curr_pos[0] + number, (curr_pos[1].ord + character).chr]
    board.each do |square|
      if square.is_a?(Array) && square == next_pos
        moves << square
      elsif !square.is_a?(Array) && square.position == next_pos
        moves << {square.position => square}
      end
    end
    check_diagonal(board, character, number, next_pos, moves)
  end

end
