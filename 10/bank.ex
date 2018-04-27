defmodule Bank do

  require Logger

  @moduledoc """
  I will use the more modern Logger provided by Elixir instead of
  the raw :error_logger from Erlang.
  """

  def account(amount) do
    case get_action("D)eposit, W)ithdraw, B)alance, Q)uit: ", [:d, :w, :b, :q]) do
      :q -> nil
      :b -> IO.puts "Your account balance is #{amount}€"
            account(amount)
      :d -> get_number("the amount to deposit")
            |> handle_deposit(amount)
            |> account
      :w -> get_number("the amount to withdraw")
            |> handle_withdraw(amount)
            |> account
    end
  end

  defp handle_deposit(value, amount) when value < 0 do
    Logger.error "Negative amount deposited."
    amount
  end
  defp handle_deposit(value, amount) do
    Logger.info "#{value} deposited."
    IO.puts "Your new account balance is #{value + amount}€"
    amount + value
  end

  defp handle_withdraw(value, amount) when value < 0 do
    Logger.error "Negative amount withdrawn."
    amount
  end
  defp handle_withdraw(value, amount) when value > amount do
    Logger.error "Overdraft !"
    amount
  end
  defp handle_withdraw(value, amount) do
    Logger.info "#{value} withdrawn."
    IO.puts "Your new account balance is #{amount - value}€"
    amount - value
  end


  @doc """
  Get a user input number. No validation done here !
  """

  @spec get_number(String.t()) :: integer()

  defp get_number(s) do
    s = IO.gets("Enter #{s} >") |> String.strip
    cond do
      Regex.match?(~r/^[0-9]+$/, s) -> String.to_integer(s)
      Regex.match?(~r/^[0-9]+\.[0-9]+$/, s) -> String.to_float(s)
      Regex.match?(~r/^[0-9]+\.[0-9]+e-?[0-9]+$/, s) -> String.to_float(s)
      true -> "NaN"
    end
  end

  @doc """
  Get an action from the user.
  """

  @spec get_action(String.t, [atom]) :: atom

  defp get_action(prompt, possibilities) do
    a = IO.gets("Enter #{prompt} >") |> String.first |> String.downcase |> String.to_atom
    case Enum.find(possibilities, fn x -> x == a end) do
      nil      -> get_action(prompt, possibilities)
      action   -> action
    end
  end

end
