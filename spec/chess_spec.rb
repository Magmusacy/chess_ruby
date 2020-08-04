require './lib/player.rb'

describe Player do
  describe "#pieces" do
    it "Assigns white pieces when we specify the color white" do
      player = Player.new("Dallas", "white")
      expect(player.pieces).to eql(%w[♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖])
    end

    it "Assigns black pieces when we specify the color black" do
      player = Player.new("Dallas", "black")
      expect(player.pieces).to eql(%w[♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜])
    end
  end
end