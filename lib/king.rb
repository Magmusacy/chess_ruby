require './lib/pawn.rb'
require './lib/chess_board.rb'
class King < Pawn
  include CommonMethods
  def legal_moves(board, illegal=false) # these are all possible moves 
    return_hash = {moves: []}
    board.each do |square|
      if square.is_a?(Array)
        return_hash[:moves] << square if find_move_row(square)
      elsif !square.is_a?(Array)
        return_hash[:moves] << {square.position => square} if find_move_row(square.position) && square.color != color
      end
    end
    return return_hash if illegal
    remove_illegal_moves(return_hash, board) # remove moves after which the king is in check
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
        new_board = Marshal.dump(board)
        player = Marshal.dump(self.parent)
        opponent_player = Marshal.dump(opponent)
        ary << check_following_moves(Marshal.load(new_king), Marshal.load(new_board), Marshal.load(player), Marshal.load(opponent_player), new_move)
      end
      ary.each { |el| el.is_a?(Hash) ? return_hash[:moves].reject!{ |move| move.is_a?(Array) && move == el.first[1] || !move.is_a?(Array) && move.first[0] == el.first[1]} : next }
      return_hash
  end

  def check_following_moves(king, board, player, opponent, new_move)
    board.map!{ |square| (square.is_a?(King) && square.color == player.color) ? square.position : square} # remove the initial opponent's king
    player.pieces, opponent.pieces = [], [] # new players and opponent objects are linked with piece objects prior to deep clone so i had to clean their pieces array and fill them with new deep cloned instances of pieces
    board.each do |piece|
      if !piece.is_a?(Array) && piece.color == player.color
        piece.parent = player
        player.pieces << piece
      elsif !piece.is_a?(Array) && piece.color == opponent.color
        piece.parent = opponent
        opponent.pieces << piece
      end
    end

    board = king.move(board, new_move, legal_moves(board, true))

    opponent.pieces.each do |piece|
      legal = piece.is_a?(King) ? beats_king?(piece.legal_moves(board, true)[:moves]) : beats_king?(piece.legal_moves(board)[:moves])
      return legal unless legal == false # return true next move is checked
    end
    return false # return false  next move isn't checked
  end

end
