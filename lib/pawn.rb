class Pawn
  attr_accessor :position, :icon, :color,:last_move
  def initialize(icon, position, color)
    @icon = icon
    @position = position
    @color = color
    @last_move = {}
  end

  def move(board, finish, available_moves = legal_moves(board))
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

  def is_legal?(board, finish, legal = legal_moves(board))
    legal = legal[:moves].map! { |move| move.is_a?(Array) ? move : move.first[0] } 
    if legal.include?(finish)
      true
    else
      puts "This move is illegal, try something different"
      false
    end
  end

  private
  
  def legal_moves(board)
    case color
    when "black"
      search_moves(board, -1)
    when "white"
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
      if !square.is_a?(Array) && square.color != self.color && square.position[0] == position[0] - row && 
        (square.position[1] == columns[letter_index - 1] || square.position[1] == columns[letter_index + 1])
          return_hash[:moves] << {square.position => square}
      end

      if square.is_a?(Pawn) && square.position[0] == position[0] && square.color != self.color && # en passant
        (square.position[1] == columns[letter_index - 1] || square.position[1] == columns[letter_index + 1]) && 
        ((square.last_move.first[0][0] - square.last_move.first[1][0]).abs == 2) &&
        board[board.index(square) - (row * 8)].is_a?(Array)
          return_hash[:moves] << {board[board.index(square) - (row * 8)] => square}
      end

    end

    return_hash
  end

  def take_enemy_piece(hash, finish, board)
    if hash[0] == finish && hash[1].position != finish # en passant special rule
      en_passant(hash, finish, board)
    elsif hash[0] == finish
      @last_move = {position => finish}
      self.position = finish 
      board.map { |square| square == hash[1] ? square = self : square } 
    else
      board
    end
  end

  def move_to_array(array, finish, board)
    if array == finish
      @last_move = {position => finish}
      self.position = finish
      board.map { |square| square == array ? square = self : square }
    else
      board
    end
  end

  def en_passant(hash, finish, board)
    @last_move = {position => finish}
    self.position = finish 
    board.map do |square|
      if square == hash[1]
        square = hash[1].position
      elsif square == finish
        square = self
      else
        square
      end
    end
  end

end

