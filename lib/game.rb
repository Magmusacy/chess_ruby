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

def king_check_move(player, board)
  king = board.find { |piece| piece.is_a?(King) && piece.parent == player }
  puts "#{player.name} is in CHECK and the only piece he can move right now is King at [#{king.position[0]}-#{king.position[1]}]"
  move = legal_position(gets.chomp)
  if move[0] != king.position
    move = king_check_move(player, board)
  elsif !king.is_legal?(board, move[1])
    move = king_check_move(player, board)
  else
    [king, move[1]]
  end
end

def play(moving_player, opponent, chess)
  if moving_player.is_mated?(opponent, chess.board)
    return false
  elsif moving_player.is_checked?(opponent, chess.board) 
    move = king_check_move(moving_player, chess.board)
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
    print "Input player 1 name (black): "; player1 = Player.new(gets.chomp, "black")
    print "Input player 2 name (white): "; player2 = Player.new(gets.chomp, "white")
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