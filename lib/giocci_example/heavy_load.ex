defmodule GiocciExample.HeavyLoad do
  def fib(0), do: 0
  def fib(1), do: 1
  def fib(n), do: fib(n - 1) + fib(n - 2)

  def parallel_fib(num, count) do
    1..count
    |> Task.async_stream(fn _ -> fib(num) end,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity
    )
    |> Enum.map(fn {:ok, val} -> val end)
  end
end
