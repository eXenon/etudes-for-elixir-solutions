defmodule Cards do
  def make_deck do
    for card <- [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"],
        color <- ["Diamond", "Heart", "Club", "Spade"], do:
        {card, color}
  end

  def make_shuffled_deck do
    make_deck()
    |> shuffle
  end

  @doc """
  This shuffle algorithm will recursively take one random element of a list
  and add it to the aggregator. This is done until the initial list is empty.

  The magic happens in the third definition of this function :
  - Split the list at a random point
  - Take the first element of the second part of the split
  - Add it the aggregator
  - Merge the first part of the split with the remainder of the second part
  - Repeat until the list is empty
  """

  def shuffle(list) do
    :random.seed(:erlang.now())
    shuffle(list, [])
  end

  def shuffle([], acc) do
    acc
  end

  def shuffle(list, acc) do
    {leading, [h | t]} =
      Enum.split(list, :random.uniform(Enum.count(list)) - 1)
      shuffle(leading ++ t, [h | acc])
  end

  @doc """
  Card comparison operators.
  """
  def {v1, _} ~> {v2, _} do
    cards = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]
    i1 = Enum.find_index(cards, fn x -> x == v1 end)
    i2 = Enum.find_index(cards, fn x -> x == v2 end)
    if i1 != i2 do
      round((i1 - i2) / abs(i1 - i2))
    else
      0
    end
  end

end


defmodule Player do

  def player do
    player([])
  end

  def player(state) do
    receive do
      {:deck, deck}    -> IO.puts "Player received deck."
                          player(deck)
      {:card, dealer}  -> handle_sending_cards(state, dealer)
                          |> player
      {:win, cards}    -> IO.puts "Player won a stack ! (#{length(state) + length(cards)} cards)"
                          player(state ++ cards)
      {:war, dealer}   -> IO.puts "Player is in a war state."
                          handle_war(state, dealer) |> player
    end
  end

  defp handle_sending_cards(state, dealer) do
    IO.puts "Player received order to send card."
    case state do
      [ c1 | cards ] -> IO.puts "Sending card to dealer."
                        send dealer, {:card, c1}
                        cards
      []             -> IO.puts "No more cards... Declaring loss."
                        send dealer, {:loss, self()}
                        []
    end
  end

  defp handle_war([ c1 | [ c2 | [ c3 | c ]]], dealer) do
    # Able to pay two cards to war stack
    send dealer, {:war, [c1, c2]}
    [c3|c]
  end
  defp handle_war([c1, c2], dealer) do
    # Able to pay one card to war stack
    send dealer, {:war, [c1]}
    [c2]
  end
  defp handle_war([c], dealer) do
    # Not able pay anything into the stack
    send dealer, {:war, []}
    [c]
  end
  defp handle_war([], dealer) do
    # Broke.
    send dealer, {:loss, self()}
  end

end

defmodule War do

  import Cards
  import Player

  def dealer do
    dealer(%{})
  end

  def dealer(state) do
    receive do
      {:start}      -> IO.puts "Starting game !"
                       p1 = spawn &player/0
                       p2 = spawn &player/0
                       {deck_p1, deck_p2} = make_shuffled_deck() |> Enum.split(26)
                       send p1, {:deck, deck_p1}
                       send p2, {:deck, deck_p2}
                       send p1, {:card, self()}
                       send p2, {:card, self()}
                       dealer(%{p1: p1, p2: p2, stack: [], tc: 0, wc: 0})
      {:card, card} -> handle_receiving_card(state, card) |> dealer
      {:war, cards} -> handle_war(state, cards) |> dealer
      {:loss, p}    -> if state.p1 == p do
                         IO.puts "Player 1 lost !!! #{state.tc} turns, #{state.wc} wars"
                       else
                         IO.puts "Player 2 lost !!! #{state.tc} turns, #{state.wc} wars"
                       end
    end
  end

  defp handle_receiving_card(%{p1: p1, p2: p2, c1: {v1, c1}, stack: s, tc: tc, wc: wc},
                             {v2, c2}) do
    IO.puts "Player 2 sent #{v2} of #{c2}"
    case {v2,c2} ~> {v1,c1} do
      -1 -> IO.puts "Player 1 won this hand !"
            send p1, {:win, [{v1,c1}, {v2,c2}] ++ s}
            send p1, {:card, self()}
            send p2, {:card, self()}
            %{p1: p1, p2: p2, stack: [], tc: tc+1, wc: wc}
      1  -> IO.puts "Player 2 won this hand !"
            send p2, {:win, [{v1,c1}, {v2,c2}] ++ s}
            send p1, {:card, self()}
            send p2, {:card, self()}
            %{p1: p1, p2: p2, stack: [], tc: tc+1, wc: wc}
      0  -> IO.puts "WAAAARRRR !!!"
            send p1, {:war, self()}
            send p2, {:war, self()}
            %{p1: p1, p2: p2, temp_stack: [{v1,c1}, {v2,c2}] ++ s, tc: tc, wc: wc+1}
    end
  end
  defp handle_receiving_card(%{p1: p1, p2: p2, stack: s, tc: tc, wc: wc},
                             {v,c}) do
    IO.puts "Player 1 sent #{v} of #{c}"
    %{p1: p1, p2: p2, c1: {v,c}, stack: s, tc: tc, wc: wc}
  end

  defp handle_war(%{p1: p1, p2: p2, temp_stack: stack, tc: tc, wc: wc},
                  cards) do
    # Only waiting for one other stack. Remove the temp.
    %{p1: p1, p2: p2, stack: cards ++ stack, tc: tc, wc: wc}
  end

  defp handle_war(%{p1: p1, p2: p2, stack: stack, tc: tc, wc: wc},
                  cards) do
    # Got all the cards, start another hand as usual, with add the cards to the stack
    send p1, {:card, self()}
    send p2, {:card, self()}
    %{p1: p1, p2: p2, stack: cards ++ stack, tc: tc, wc: wc}
  end

end

