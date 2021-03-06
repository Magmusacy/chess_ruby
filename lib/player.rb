require './lib/piece.rb'
require './lib/pawn.rb'
require './lib/rook.rb'
require './lib/knight.rb'
require './lib/queen.rb'
require './lib/king.rb'
require './lib/bishop.rb'
require './lib/common_methods.rb'
class Player
attr_accessor :pieces
attr_reader :type, :name, :color
include CommonMethods
  def initialize(name, color, type="human")
    @name = name
    @color = color 
    @pieces = create_pieces(color)
    @type = type
  end

  def create_pieces(color)
    case color 
    when "black"
      pieces = assign_pieces_array(["♜", "♞","♝","♛","♚","♝","♞","♜","♟︎"], 8, 7)
    when "white"
      pieces = assign_pieces_array(["♖","♘","♗","♕","♔","♗","♘","♖","♙"], 1, 2)
    end
  end

  def is_checked?(other_player, board, msg=true, show_piece=false, return_ary=[])
    other_player.pieces.each do |piece|
      return_ary.concat beats_king?(piece.legal_moves(board)[:moves], true) if beats_king?(piece.legal_moves(board)[:moves], true).is_a?(Array)
    end
    if !return_ary.empty?
      puts "#{self.name} is CHECKED by #{other_player.name}" if msg
      return return_ary if show_piece
      return true
    end
    false
  end

  def is_mated?(other_player, board, ary = []) 
    return false if is_checked?(other_player, board, false) == false
    king = pieces.find{ |piece| piece.is_a? King }
    if king.legal_moves(board)[:moves].empty?
      puts "#{self.name} is MATED by #{other_player.name}, #{other_player.name} WINS!"
      return true
    else
      false
    end
  end

  def stalemate?(other_player, board)
    return false if is_checked?(other_player, board) == true
    pieces.each do |piece|
      unless piece.legal_moves(board)[:moves].empty?
        return false
      end
    end
    puts "STALEMATE the game is a draw"
    return true
  end 

  def ai_legal_moves(board)
    moves_hash = @pieces.reduce({}) do |accumulator, piece|
      accumulator[piece] = piece.legal_moves(board)[:moves] unless piece.legal_moves(board)[:moves].empty?
      accumulator
    end
    random_piece = moves_hash.keys.sample
    [random_piece, moves_hash[random_piece].sample]
  end

  private

  def assign_pieces_array(array, start, finish)
    return_ary = [Rook.new(array[0], [start, "a"], color, self), Knight.new(array[1], [start, "b"], color, self), Bishop.new(array[2], [start, "c"], color, self), Queen.new(array[3], [start, "d"], color, self), King.new(array[4], [start, "e"], color, self), Bishop.new(array[5], [start, "f"], color, self), Knight.new(array[6], [start, "g"], color, self), Rook.new(array[7], [start, "h"], color, self)]
    8.times { |i| return_ary << Pawn.new(array[8], [finish, (97 + i).chr], color, self) }
    return_ary
  end

end
