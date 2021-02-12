class Piece
  attr_accessor :position, :icon, :color,:last_move, :parent
  def initialize(icon, position, color, parent)
    @icon = icon
    @position = position
    @color = color
    @parent = parent
    @last_move = {}
  end

  def move(board, finish, available_moves = legal_moves(board))
    board.map! { |square| square == self ? square = self.position : square }
    available_moves[:moves].each do |move| 
      if move.is_a?(Hash) && move.first[1].is_a?(Array)
        new_board = castling_move(move, finish, board)
        return new_board if new_board != board
      elsif move.is_a?(Hash)
        new_board = take_enemy_piece(move.first, finish, board)
        return new_board if new_board != board
      else
        new_board = move_to_array(move, finish, board)
        return new_board if new_board != board
      end
    end
  end

  def is_legal?(board, finish, legal = legal_moves(board))
    legal = legal[:moves].map! { |move| move.is_a?(Array) ? move : move.first[0] } 
    if legal.include?(finish)
      true
    else
      puts "This move is illegal, try something different"
      puts "Legal moves for this piece are: "
      legal.each { |move| puts "[#{move[0]}-#{move[1]}]" }
      false
    end
  end

  private

  def take_enemy_piece(hash, finish, board)
    if hash[0] == finish && hash[1].position != finish # en passant special rule 
      en_passant(hash, finish, board)
    elsif hash[0] == finish
      @last_move = {position => finish}
      hash[1].parent.pieces.delete(hash[1]) # deletes the piece from opponent's pieces array
      self.position = finish 
      board.map { |square| square == hash[1] ? square = self : square } 
    else
      board
    end
  end

  def move_to_array(array, finish, board)
    if array == finish && self.instance_of?(Pawn) && (finish[0] == 8 || finish[0] == 1)
      new_piece = promotion(finish, board)
      self.parent.pieces << new_piece
      self.parent.pieces.delete(self) 
      board.map { |square| square == array ? square = new_piece : square }
    elsif array == finish
      @last_move = {position => finish}
      self.position = finish
      board.map { |square| square == array ? square = self : square }
    else
      board
    end
  end

end