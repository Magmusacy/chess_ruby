class Player
attr_reader :name, :pieces
  def initialize(name, pieces)
    @name = name
    @pieces = pieces == "white" ? %w[♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖] : %w[♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜]
  end
end
