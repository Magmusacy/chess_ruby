require './lib/pawn.rb'
class Rook < Pawn
  def move(board, finish)
    available_moves = legal_moves(board, finish) 
    board.map! { |square| square == self ? square = self.position : square }
    available_moves[:moves].each do |move|
      if move.is_a?(Hash)
        old_board = board
        new_board = take_enemy_piece(move.first, finish, board)
        return new_board if old_board != new_board
      else
        old_board = board
        new_board = move_to_array(move, finish, board)
        return new_board if old_board != new_board
      end
    end
  end

  def is_legal?(board, finish)
    legal = legal_moves(board, finish)[:moves].map { |move| move.is_a?(Array) ? move : move.first[0] } 
    if legal.include?(finish)
      true
    else
      puts "This move is illegal, try something different"
      false
    end
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
