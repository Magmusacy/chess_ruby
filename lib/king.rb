require './lib/pawn.rb'
require './lib/chess_board.rb'
class King < Pawn
  include CommonMethods
  def legal_moves(board, illegal=false, in_check=false) # these are all possible moves 
    return_hash = {moves: []}
    board.each do |square|
      if square.is_a?(Array)
        return_hash[:moves] << square if find_move_row(square)
      elsif !square.is_a?(Array)
        return_hash[:moves] << {square.position => square} if find_move_row(square.position) && square.color != color
      end
    end
    return return_hash if illegal
    correct_moves = remove_illegal_moves(return_hash, board) # remove moves after which the king is in check
    correct_moves[:moves].concat(castling(board)[:moves]) 
    correct_moves
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

  def remove_illegal_moves(return_hash, board, ary = []) 
      opponent = board.find{|x| !x.is_a?(Array) && x.color != self.color}.parent
      king_moves = return_hash[:moves]
      king_moves.count.times do |move|
        king_moves[move].is_a?(Array) ? (new_move = king_moves[move]) : (new_move = king_moves[move].first[0]) 
        new_king = Marshal.dump(self)
        player = Marshal.dump(self.parent)
        opponent_player = Marshal.dump(opponent)
        ary << check_following_moves(Marshal.load(new_king), ChessBoard.new, Marshal.load(player), Marshal.load(opponent_player), new_move)
      end
      ary.each { |el| el.is_a?(Hash) ? return_hash[:moves].reject!{ |move| move.is_a?(Array) && move == el.first[1] || !move.is_a?(Array) && move.first[0] == el.first[1]} : next }
      return_hash
  end

  def check_following_moves(king, chess, player, opponent, new_move)
    player.pieces.reject!{ |piece| piece.is_a?(King) } # remove player's initial king
    
    chess.assign_board_squares(player)
    chess.assign_board_squares(opponent)
    chess.board = king.move(chess.board, new_move, legal_moves(chess.board, true))

    return king_in_check?(opponent, chess.board) 
  end

  def king_in_check?(opponent, board)
    opponent.pieces.each do |piece|
      legal = piece.is_a?(King) ? beats_king?(piece.legal_moves(board, true)[:moves]) : beats_king?(piece.legal_moves(board)[:moves])
      return legal unless legal == false # return true next move is checked
    end
    false
  end

  def castling(board, return_hash = {moves: []})
    rooks = board.select { |piece| piece.is_a?(Rook) && piece.color == color && piece.last_move.empty? }
    king_check = is_attacked?(board, self) == false ? false : true
    if last_move.empty? && !king_check
        rooks.each do |rook|
          king_col = self.position[1].ord
          rook_col = rook.position[1].ord
          free_path = king_col > rook_col ? free_space?(rook, board, king_col, rook_col) : free_space?(rook, board, rook_col, king_col)
          king_move = calculate_new_position(king_col, rook_col, 2)
          rook_move = calculate_new_position(king_col, rook_col, 1)
          return_hash[:moves] << {king_move => [self, rook_move, rook]} if free_path
        end 
    end
    return_hash
  end

  def calculate_new_position(king_col, rook_col, move)
    diff = (king_col - rook_col).abs - 1
    diff == 3 ? [self.position[0], (king_col - move).chr] : [self.position[0], (king_col + move).chr]
  end 

  def free_space?(rook, board, minuend, subtrahend, ary=[]) 
    board_free_spaces = board.select{ |square| square.is_a?(Array) }
    count = minuend - subtrahend-1
      1.upto(count) do |i|
        ary << !is_attacked?(board, [self.position[0], (subtrahend + i).chr]) unless (count == 3 && i == 1) 
        ary << board_free_spaces.include?([self.position[0], (subtrahend + i).chr]) 
      end
    ary.all?{ |el| el == true }
  end

  def is_attacked?(board, square)
    opponent = board.find{ |sqr| sqr.is_a?(King) && sqr != self }.parent
    return king_in_check?(opponent, board) if square == self
    opponent.pieces.each do |piece|
      legal = piece.is_a?(King) ? piece.legal_moves(board, true)[:moves] : piece.legal_moves(board)[:moves]
      return true if legal.include?(square)
    end
    false
  end

end
