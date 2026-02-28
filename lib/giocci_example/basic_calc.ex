defmodule GiocciExample.BasicCalc do
  def add(a, b), do: a + b
  def multiply(a, b), do: a * b
  def power(a, b), do: :math.pow(a, b)

  def fib(0), do: 0
  def fib(1), do: 1
  def fib(n), do: fib(n - 1) + fib(n - 2)
end
