require './lib/pawn.rb'
require './lib/rook.rb'
require './lib/knight.rb'
require './lib/queen.rb'
require './lib/king.rb'
require './lib/bishop.rb'
class Player
attr_accessor :name, :pieces, :color
  def initialize(name, color)
    @name = name
    @color = color 
    @pieces = create_pieces(color)
  end

  def create_pieces(color)
    case color 
    when "black"
      pieces = assign_pieces_array(["♜", "♞","♝","♛","♚","♝","♞","♜","♟︎"], 8, 7)
    when "white"
      pieces = assign_pieces_array(["♖","♘","♗","♕","♔","♗","♘","♖","♙"], 1, 2)
    end
  end

  def check?(other_player, board)
    pieces.each do |piece|
      if beats_king?(piece.legal_moves(board)[:moves])
        return puts "#{self.name} CHECKS #{other_player.name}" 
      end
    end
    false
  end

  def mate?(other_player, board, ary = []) # if checks 
    return false if check?(other_player, board.board) == false
    if king_moves(other_player, board).all? {|el| el == true}
      puts "#{self.name} MATES #{other_player.name}, #{self.name} wins this game" 
      true
    end
  end

  def stalemate?(other_player, board)
    return false if check?(other_player, board.board) == true
    if king_moves(other_player, board).all? {|el| el == true} 
      puts "#{self.name} STALEMATES #{other_player.name}, the game is a draw" 
      true
    end
  end

  private

  def king_moves(other_player, board, ary = [])
    king = other_player.pieces.find{|x| x.is_a? King} 
    king_moves = king.legal_moves(board.board)[:moves] # find all potentional legal moves for king
    king_moves.count.times do |move|
      king_moves[move].is_a?(Array) ? (new_move = king_moves[move]) : (new_move = king_moves[move].first[0]) 
      new_king = Marshal.dump(king)
      new_board = Marshal.dump(board)
      player = Marshal.dump(self)
      opponent = Marshal.dump(other_player)
      ary << check_following_moves(Marshal.load(new_king), Marshal.load(new_board), Marshal.load(player), Marshal.load(opponent), new_move)
    end
    ary
  end

  def check_following_moves(king, board, player, opponent, new_move)
    board.board.map!{|x| (x.is_a?(King) && x.color == opponent.color) ? x.position : x} # remove the initial opponent's king
    player.pieces, opponent.pieces = [], [] # new players and opponent objects are linked with piece objects prior to deep clone so i had to clean their pieces array and fill them with new deep cloned instances of pieces
    board.board.each do |piece|
      if !piece.is_a?(Array) && piece.color == player.color
        piece.parent = player
        player.pieces << piece
      elsif !piece.is_a?(Array) && piece.color == opponent.color
        piece.parent = opponent
        opponent.pieces << piece
      else
        next
      end
    end
    board.board = king.move(board.board, new_move)
    player.pieces.each do |piece|
      return true if beats_king?(piece.legal_moves(board.board)[:moves]) # return true if next move is checked
    end
    return false # return false if next move isn't checked
  end
  
  def beats_king?(ary)
    ary.each { |move| return true if move.is_a?(Hash) && move.first[1].is_a?(King) } 
    false
  end


  def assign_pieces_array(array, start, finish)
    return_ary = [Rook.new(array[0], [start, "a"], color, self), Knight.new(array[1], [start, "b"], color, self), Bishop.new(array[2], [start, "c"], color, self), Queen.new(array[3], [start, "d"], color, self), King.new(array[4], [start, "e"], color, self), Rook.new(array[5], [start, "f"], color, self), Knight.new(array[6], [start, "g"], color, self), Bishop.new(array[7], [start, "h"], color, self)]
    8.times { |i| return_ary << Pawn.new(array[8], [finish, (97 + i).chr], color, self) }
    return_ary
  end

end
