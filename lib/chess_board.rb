class ChessBoard

  def initialize
    @board = Array("a".."h").product(Array(1..8))
    @occupied = []
  end
end