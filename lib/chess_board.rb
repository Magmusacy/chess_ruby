# create chess board class
# initialize it with vertical columns 1..8 and horizontal rows a..h
# add an array of occupied squares to the initialize and update it with every move of the pieces

class ChessBoard

  def initialize
    @board = Array("a".."h").product(Array(1..8))
    @occupied = []
  end
  
end