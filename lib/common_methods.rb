module CommonMethods

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

  def search_moves(board, direction, return_hash = {moves: []})
    current_row = board.select{ |square| (square.is_a?(Array) && square[direction] == position[direction]) || (!square.is_a?(Array) && square.position[direction] == position[direction])}
    self_index = current_row.index(self)
    left_part = current_row[0..self_index].reverse - [self] # left part of the array starting from self position
    right_part = current_row[self_index..-1] - [self] # left part of the array starting from self position
    return_hash = find_path(left_part, {moves: []})
    return_hash = find_path(right_part, return_hash)
    p return_hash
  end

  def find_path(array, return_hash)
    array.each do |square| 
      if square.is_a? Array
        return_hash[:moves] << square
      else
        return_hash[:moves] << {square.position => square} if square.color != color
        break
      end 
    end
    return_hash
  end
  
end