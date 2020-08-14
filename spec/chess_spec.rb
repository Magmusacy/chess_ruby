require './lib/player'
require './lib/chess_board'
describe Player do
  it "Assigns correct piece instances to correct color (white)" do
    player = Player.new("Taco Hemingway", "white")
    expect(player.pieces.last.icon).to eql("♙")
  end

  it "Assigns correct piece instances to correct color (black)" do
    player = Player.new("Taco Hemingway", "black")
    expect(player.pieces.last.icon).to eql("♟︎")
  end
end

describe Player do
  it "Outputs that opponent is mated if he is" do
    white = Player.new("Taco", "white")
    white.pieces = []
    white.pieces << Rook.new("♖", [1, "h"], "white", white)
    white.pieces << King.new("♔", [5, "f"], "white", white)
    black = Player.new("Hemingway", "black")
    black.pieces = []
    black.pieces << King.new("♚", [5, "h"], "black", black)
    board = ChessBoard.new
    board.assign_board_squares(white)
    board.assign_board_squares(black)
    expect(white.mate?(black, board)).to eql(true)
  end

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
    expect(white.mate?(black, board)).to_not eql(false)
  end

  it "Doesn't return anything if opponent isn't checked/mated" do
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
    expect(white.mate?(black, board)).to eql(false)
  end

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
    expect(white.stalemate?(black, board)).to eql(true)
  end

  it "Recognizes stalemate on different positions" do
    white = Player.new("Taco", "white")
    white.pieces = []
    white.pieces << Pawn.new("♙", [7, "d"], "white", white)
    white.pieces << King.new("♔", [6, "d"], "white", white)
    black = Player.new("Hemingway", "black")
    black.pieces = []
    black.pieces << King.new("♚", [8, "d"], "black", black)
    board = ChessBoard.new
    board.assign_board_squares(white)
    board.assign_board_squares(black)
    expect(white.stalemate?(black, board)).to eql(true)
  end
end