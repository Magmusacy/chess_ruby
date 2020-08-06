class Pawn
  attr_accessor :position, :icon, :last_move
  def initialize(icon, position)
    @icon = icon
    @position = position
    @last_move = {}
  end

  def move(board, finish)
    available_moves = legal_moves(board) 
    available_moves[:moves].each do |move|
      board.map! { |square| square == self ? square = self.position : square }
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

  private
  
  def legal_moves(board)
    case icon
    when "♟︎"
      search_moves(board, -1)
    when "♙"
      search_moves(board, 1)
    end 
  end

  def search_moves(board, row, return_hash = {moves: []})
    columns = Array("a".."h")
    letter_index = columns.index(position[1])

    if @last_move.empty? 
      moves = board.select { |move| move.is_a?(Array) && move[1] == position[1] && (position[0] - row == move[0] || position[0] - row*2 == move[0]) }
      moves.each { |move| return_hash[:moves] << move}
    end
    
    if !@last_move.empty? && position[0] != 1 # later on i have to add here transition from pawn to queen... etc
      moves = board.select { |move| move.is_a?(Array) && move[1] == position[1] && position[0] - row == move[0] }
      moves.each { |move| return_hash[:moves] << move}
    end

    board.each do |square|
      if !square.is_a?(Array) && square.icon != self.icon && square.position[0] == position[0] - row && (square.position[1] == columns[letter_index - 1] || square.position[1] == columns[letter_index + 1])
        return_hash[:moves] << {square.position => square}
      end

      #if square.is_a?(Pawn) && square.position[0] == position[0] && square.icon != self.icon && (square.position[1] == columns[letter_index - 1] || square.position[1] == columns[letter_index + 1]) && (square.last_move.first[0] - square.last_move.first[1] == 2) # en passant
      #  return_hash[:moves] << {square.position => square}
      #end

    end

    return_hash
  end

  def take_enemy_piece(hash, finish, board)
    if hash[0] == finish
      @last_move[position] = finish
      self.position = finish if hash[0] == finish
      board.map { |square| square == hash[1] ? square = self : square } 
    else
      board
    end
  end

  def move_to_array(array, finish, board)
    if array == finish
      @last_move[position] = finish
      self.position = finish
      board.map { |square| square == array ? square = self : square }
    else
      board
    end
  end

end

