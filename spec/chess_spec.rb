require './lib/player'
require './lib/chess_board'

describe Player do

  describe "#check" do
    it "Outputs that opponent is checked if he is" do
      white = Player.new("Taco", "white")
      white.pieces = []
      white.pieces << Rook.new("♖", [2, "c"], "white", white)
      white.pieces << King.new("♔", [1, "e"], "white", white)
      black = Player.new("Hemingway", "black")
      black.pieces = []
      black.pieces << King.new("♚", [6, "c"], "black", black)
      board = ChessBoard.new
      board.assign_board_squares(white)
      board.assign_board_squares(black)
      expect(black.is_checked?(white, board.board)).to eql(true)
    end

    it "Shows if player is attacked by two opponent pieces" do
      white = Player.new("Taco", "white")
      white.pieces = []
      white.pieces << Rook.new("♖", [2, "c"], "white", white)
      white.pieces << King.new("♔", [1, "c"], "white", white)
      white.pieces << Knight.new("♘", [6, "d"], "white", white)
      black = Player.new("Hemingway", "black")
      black.pieces = []
      black.pieces << King.new("♚", [8, "c"], "black", black)
      board = ChessBoard.new
      board.assign_board_squares(white)
      board.assign_board_squares(black)
      expect(black.is_checked?(white, board.board, false, true).length).to eql(2)
    end
  end

  describe "#mate" do
    it "Outputs that opponent is mated if he is" do
      white = Player.new("Taco", "white")
      white.pieces = []
      white.pieces << Rook.new("♖", [1, "h"], "white", white)
      white.pieces << Rook.new("♖", [5, "g"], "white", white)
      white.pieces << King.new("♔", [5, "f"], "white", white)
      black = Player.new("Hemingway", "black")
      black.pieces = []
      black.pieces << King.new("♚", [5, "h"], "black", black)
      board = ChessBoard.new
      board.assign_board_squares(white)
      board.assign_board_squares(black)
      expect(black.is_mated?(white, board.board)).to eql(true)
    end
    
    it "Returns false if black isn't mated" do
      white = Player.new("Taco", "white")
      white.pieces = []
      white.pieces << Rook.new("♖", [2, "d"], "white", white)
      white.pieces << King.new("♔", [1, "e"], "white", white)
      black = Player.new("Hemingway", "black")
      black.pieces = []
      black.pieces << King.new("♚", [6, "c"], "black", black)
      board = ChessBoard.new
      board.assign_board_squares(white)
      board.assign_board_squares(black)
      expect(black.is_mated?(white, board.board)).to eql(false)
    end
  end

  describe "#stalemate" do

    it "Recognizes stalemate" do
      white = Player.new("Taco", "white")
      white.pieces = []
      white.pieces << Queen.new("♕", [6, "g"], "white", white)
      white.pieces << King.new("♔", [7, "f"], "white", white)
      black = Player.new("Hemingway", "black")
      black.pieces = []
      black.pieces << King.new("♚", [8, "h"], "black", black)
      board = ChessBoard.new
      board.assign_board_squares(white)
      board.assign_board_squares(black)
      expect(black.stalemate?(white, board.board)).to eql(true)
    end

    it "Doesn't return stalemate if king is checked" do
      white = Player.new("Taco", "white")
      white.pieces = []
      white.pieces << Pawn.new("♙", [7, "d"], "white", white)
      white.pieces << King.new("♔", [6, "d"], "white", white)
      white.pieces << Rook.new("♖", [8,"h"], "white", white)
      black = Player.new("Hemingway", "black")
      black.pieces = []
      black.pieces << King.new("♚", [8, "d"], "black", black)
      board = ChessBoard.new
      board.assign_board_squares(white)
      board.assign_board_squares(black)
      expect(black.stalemate?(white, board.board)).to eql(false)
    end
  end
  
  describe "#ai_legal_moves" do
    it "Returns random piece with its legal moves" do
      white = Player.new("Taco", "white")
      black = Player.new("Hemingway", "black")
      board = ChessBoard.new
      board.assign_board_squares(white)
      board.assign_board_squares(black)
      p black.ai_legal_moves(board.board)
    end
  end

end

describe Pawn do
  it "Promotes itself to better piece when reached end of the board" do
    white = Player.new("Taco", "white")
    white.pieces = []
    pawn = Pawn.new("♙", [7, "h"], "white", white)
    white.pieces << pawn
    white.pieces << King.new("♔", [6, "d"], "white", white)
    black = Player.new("Hemingway", "black")
    black.pieces = []
    black.pieces << King.new("♚", [8, "d"], "black", black)
    board = ChessBoard.new
    board.assign_board_squares(white)
    board.assign_board_squares(black)
    puts board
    board.board = pawn.move(board.board, [8, 'h'])
    puts board
  end
end

describe King do
  describe "#castling" do
    it "Works correctly" do
      board = ChessBoard.new
      white = Player.new("Taco", "white")
      white.pieces = []
      rook1 = Rook.new("♖", [1, "a"], "white", white)
      rook2 = Rook.new("♖", [1, "h"], "white", white)
      king = King.new("♔", [1, "e"], "white", white)
      white.pieces = [rook1, rook2, king]
      black = Player.new("Hemingway", "black")
      board.assign_board_squares(white)
      board.assign_board_squares(black)
      puts board
      board.board = king.move(board.board, [1, "g"])
      puts board
    end
  end
end