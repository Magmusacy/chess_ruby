require './lib/chess_board'
require 'yaml'
def legal_position(move, legal_moves=Array(1..8).product(Array("a".."h"))) # checks if specified move is even on the board
  move = move.split(":")
  move.map! { |move| move.split("-"); [move[0].to_i, move[2]] }
  if !legal_moves.include?(move[0]) || !legal_moves.include?(move[1])
    puts "This move is beyond the scope of this board... Input something more reasonable"
    move = legal_position(gets.chomp)
  else
    move
  end
end

def move_piece(player, board)
  return player.ai_legal_moves(board) if player.type == "AI"
  puts "Specify which piece you want to move #{player.name}, and to what position eg. \n7-g:6-g"
  move = legal_position(gets.chomp)
  moving_piece = board.find do |piece|
    piece.class != Array && piece.position == move[0] 
  end
  if moving_piece.nil? || !moving_piece.is_legal?(board, move[1])
    moving_piece = move_piece(player, board)
  elsif !player.pieces.include?(moving_piece)
    puts "This piece belongs to your opponent..."
    moving_piece = move_piece(player, board)
  else
    [moving_piece, move[1]] 
  end
end

def king_check_move(player, board, pieces_attacking)
  king = board.find { |piece| piece.is_a?(King) && piece.parent == player }
  puts "#{player.name} is in CHECK and he must capture opponent's attacking piece"
  available_moves = []
  if pieces_attacking == 1
    available_moves = find_check_movable_pieces(player, board)
  end
  move = player.type == "AI" ? move_piece(player, board) : legal_position(gets.chomp)  
  if available_moves.include?(move)
    [board.find{ |piece| !piece.is_a?(Array) && piece.position == move[0]}, move[1]] 
  elsif move[0] != king.position
    move = king_check_move(player, board, pieces_attacking)
  elsif !king.is_legal?(board, move[1])
    move = king_check_move(player, board, pieces_attacking)
  else
    [king, move[1]]
  end
end

def find_check_movable_pieces(player, board)
  opponent = board.find{ |piece| !piece.is_a?(Array) && piece.parent != player }.parent
  attacking_piece = nil
  opponent.pieces.each { |piece| piece.legal_moves(board)[:moves].detect{ |el| el.is_a?(Hash) && el.first[1].is_a?(King) }.nil? ? next : attacking_piece = [piece, piece.legal_moves(board)[:moves]] } # find attacking piece
  movable_pieces = []
  player.pieces.each do |piece|
    taken_piece = piece.legal_moves(board)[:moves].select{ |move| move.is_a?(Hash) && move.first[0] == attacking_piece[0].position }
    movable_pieces << [piece.position, attacking_piece[0].position] unless taken_piece.empty?
    moves = piece.legal_moves(board)[:moves] & attacking_piece[1] 
    moves.length.times do |move|
    movable_pieces << [piece.position, moves[move]] unless move_stops_check?(Marshal.dump(player), Marshal.dump(opponent), piece, moves[move]) 
    end
  end
  movable_pieces
end

def move_stops_check?(player, opponent, piece, move)
  player = Marshal.load(player)
  opponent = Marshal.load(opponent)
  piece = player.pieces.find{ |element| piece.position == element.position }
  chess = ChessBoard.new
  chess.assign_board_squares(player)
  chess.assign_board_squares(opponent)
  chess.board = piece.move(chess.board, move)
  player.is_checked?(opponent, chess.board, false)
end

def play(moving_player, opponent, chess)
  if moving_player.is_mated?(opponent, chess.board)
    return false
  elsif moving_player.is_checked?(opponent, chess.board) 
    move = king_check_move(moving_player, chess.board, moving_player.is_checked?(opponent, chess.board, false, true).length)
  elsif moving_player.stalemate?(opponent, chess.board) 
    return false
  else
    move = move_piece(moving_player, chess.board)
  end
end

def save_game(player1, player2, turn)
  player1 = YAML.dump(player1)
  player2 = YAML.dump(player2) 
  turn = YAML.dump(turn)
  puts "Choose a name for your save, remember that using a name that is already in use will cause permament override of previous save"
  save_name = gets.chomp
  file = File.open("./saves/#{save_name}.yaml", "w") do |line| 
    line.puts player1
    line.puts player2
    line.puts turn
  end
end

def load_game
  saves = Dir.glob("saves/*")
  saves.each_with_index { |save, idx| puts "#{save.gsub("saves/", "")} - #{idx}" }
  puts "Above are your current saves with indexes, type index of a save that you want to load (NOTE: if you type wrong index/string you'll load default save which is at index 0)"
  index = gets.to_i
  objects = YAML.load_stream(File.read(saves[index])) # load_stream is a method to load multiple objects from one YAML file
end

def choose_opponent(opponent)
  print "Input player 1 name (white): "; player1 = Player.new(gets.chomp, "white")
  if opponent.upcase == "AI"
    print "player 2 (black) is an AI"; player2 = Player.new("AI", "black", "AI")
  else
    print "Input player 2 name (black): "; player2 = Player.new(gets.chomp, "black")
  end
  puts
  [player1, player2]
end


def game
  puts "Welcome to chess created by Magmusacy"

  if !Dir.glob("saves/*").empty?
    puts "Type (L) to load a save, (ANY KEY) to skip" 
    answer = gets.chomp
  else
    answer = ""
  end

  if answer.upcase == "L"
    chosen_save = load_game
    player1 = chosen_save[0]
    player2 = chosen_save[1]
    turn = chosen_save[2]
  else
    puts "You can choose to play against artificial inteligence by typing AI, or other human, by typing anything else"
    players = choose_opponent(gets.chomp)
    player1, player2 = players[0], players[1]
    turn = 0
  end

  chess = ChessBoard.new
  chess.assign_board_squares(player1)
  chess.assign_board_squares(player2)

  game_status = true
  until game_status == false
    puts chess
    puts "Do you wish to save your progress? (Y), (ANY KEY) to skip"; answer = gets.chomp
    save_game(player1, player2, turn) if answer.upcase == "Y"
    move = play(player1, player2, chess) if turn.even?
    move = play(player2, player1, chess) if turn.odd?
    chess.board = move == false ? chess.board : move[0].move(chess.board, move[1])
    game_status = move
    turn += 1
  end
end

game