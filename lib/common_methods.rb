module CommonMethods

  def check_diagonal(board, character, number, curr_pos, moves = [])
    next_pos = [curr_pos[0] + number, (curr_pos[1].ord + character).chr]
    return moves if moves.any? { |el| el.is_a?(Hash) } || !Array(1..8).product(Array('a'..'h')).include?(next_pos)
    board.each do |square|
      return moves if !square.is_a?(Array) && square.position == next_pos && square.color == self.color
      if square.is_a?(Array) && square == next_pos
        moves << square
      elsif !square.is_a?(Array) && square.position == next_pos && square.color != self.color
        moves << {square.position => square} 
      end
    end
    check_diagonal(board, character, number, next_pos, moves)
  end

  def search_moves(board, direction, return_hash = {moves: []})
    current_row = board.select{ |square| (square.is_a?(Array) && square[direction] == position[direction]) || (!square.is_a?(Array) && square.position[direction] == position[direction])}
    self_index = current_row.index(self)
    left_part = current_row[0...self_index].reverse # left part of the array starting from self position
    right_part = current_row[self_index+1..-1] # left part of the array starting from self position
    return_hash = find_path(left_part, {moves: []})
    return_hash = find_path(right_part, return_hash)
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

  def beats_king?(ary, show_ary=false, return_ary=[])
    ary.each { |move| return_ary << {true => move.first[0]} if move.is_a?(Hash) && move.first[1].is_a?(King) } 
    if !return_ary.empty?
      return return_ary if show_ary
      return return_ary[0]
    end
    false
  end
  
end