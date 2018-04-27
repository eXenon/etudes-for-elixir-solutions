defmodule Cards do

  def make_deck do
    for card <- ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "V", "Q", "K"],
        color <- ["Diamond", "Heart", "Club", "Spade"], do:
        {card, color}
  end

end
