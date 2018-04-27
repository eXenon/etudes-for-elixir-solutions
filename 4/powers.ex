defmodule Powers do

  import Kernel, except: [raise: 2]

  def raise(_, 0) do
    1
  end
  def raise(x, 1) do
    x
  end
  def raise(x, n) when n > 0 do
    raise(x, n, 1)
  end
  def raise(x, n) when n < 0 do
    1 / (x * raise(x, -n))
  end
  def raise(_, 0, acc) do
    acc
  end
  def raise(x, n, acc) when n > 0 do
    raise(x, n - 1, x * acc)
  end

  def nth_root(x, n) do
    nth_root(x, n, x/2.0)
  end
  def nth_root(x, n, a) do
    f = raise(a, n) - x
    f_prime = raise(a, n - 1) * n
    next = a - f / f_prime
    change = abs(next - a)
    IO.puts("Current guess is #{next} (#{change})")
    if change < 1.0e-8 do
      next
    else
      nth_root(x, n, next)
    end
  end
      

end
