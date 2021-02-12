require './lib/common_methods.rb'
class Pawn < Piece
  
  def legal_moves(board)
    case color
    when "black"
      search_moves(board, 1)
    when "white"
      search_moves(board, -1)
    end 
  end

  private

  def search_moves(board, row, return_hash = {moves: []})
    columns = Array("a".."h")
    letter_index = columns.index(position[1])

    if @last_move.empty? 
      moves = board.select { |move| move.is_a?(Array) && move[1] == position[1] && (position[0] - row == move[0] || position[0] - row*2 == move[0]) }
      moves.each { |move| return_hash[:moves] << move}
    end
    
    if !@last_move.empty? 
      moves = board.select { |move| move.is_a?(Array) && move[1] == position[1] && position[0] - row == move[0] }
      moves.each { |move| return_hash[:moves] << move}
    end

    board.each do |square|
      if !square.is_a?(Array) && square.color != self.color && square.position[0] == position[0] - row && 
        (square.position[1] == columns[letter_index - 1] || square.position[1] == columns[letter_index + 1])
          return_hash[:moves] << {square.position => square}
      end

      if square.instance_of?(Pawn) && square.position[0] == position[0] && square.color != self.color && # en passant 
        (square.position[1] == columns[letter_index - 1] || square.position[1] == columns[letter_index + 1]) && 
        !square.last_move.empty? && 
        ((square.last_move.first[0][0] - square.last_move.first[1][0]).abs == 2) &&
        board[board.index(square) + (row * 8)].is_a?(Array)
          return_hash[:moves] << {board[board.index(square) + (row * 8)] => square}
      end

    end

    return_hash
  end

  def en_passant(hash, finish, board)
    @last_move = {position => finish}
    hash[1].parent.pieces.delete(hash[1]) # deletes the piece from opponent's pieces array
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

  def promotion(finish, board)
    icons = finish[0] == 1 ? ["♜", "♞","♝","♛"] : ["♖","♘","♗","♕"]
    options = {
      queen: Queen.new(icons[3], finish, self.color, self.parent),
      rook: Rook.new(icons[0], finish, self.color, self.parent),
      knight: Knight.new(icons[1], finish, self.color, self.parent),
      bishop: Bishop.new(icons[2], finish, self.color, self.parent)
    }
    puts "Choose between Rook, Knight, Bishop and Queen\nJust type one of these in terminal"
    choice = options[gets.chomp.intern]
    choice = promotion(finish, board) if choice.nil?
    choice
  end

  def castling_move(hash, king_move, board)
    if hash.first[0] == king_move
      @last_move = {position => king_move}
      self.position = king_move
      board.map do |square| 
        square = self if square == king_move
        if square == hash.first[1][1]
          board = hash.first[1][2].move(board, square) 
          return castling_move(hash, king_move, board)
        end
        square
      end
    else
      board
    end
  end

end

