require './lib/pawn.rb'
class King < Pawn

  def legal_moves(board) 
    return_hash = {moves: []}
    board.each do |square|
      if square.is_a?(Array)
        return_hash[:moves] << square if find_move_row(square)
      elsif !square.is_a?(Array)
        return_hash[:moves] << {square.position => square} if find_move_row(square.position) && square.color != color
      end
    end
    return_hash
  end

  private

  def find_move_row(square) 
    case square[0] - position[0]
    when -1 # upper row
      find_move_column(square)
    when 1 # lower row
      find_move_column(square)
    when 0 # current row
      find_move_column(square)
    else
      false
    end
  end

  def find_move_column(square)
    return true if (square[1].ord + 1).chr == position[1] || (square[1].ord - 1).chr == position[1] || square[1] == position[1]
    false
  end

end
