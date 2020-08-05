require './lib/player.rb'

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