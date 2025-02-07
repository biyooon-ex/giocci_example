defmodule GiocciExample do
  @moduledoc """
  Documentation for `GiocciExample`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> GiocciExample.hello()
      :world

  """
  def hello do
    :world
  end

  def add({a, b}) do
    start_time = System.monotonic_time(:microsecond)
    result = a + b
    finish_time = System.monotonic_time(:microsecond)
    processing_time = finish_time - start_time
    [result, processing_time]
  end

  def sub({a, b}) do
    start_time = System.monotonic_time(:microsecond)
    result = a - b
    finish_time = System.monotonic_time(:microsecond)
    processing_time = finish_time - start_time
    [result, processing_time]
  end

  def world(name) do
    start_time = System.monotonic_time(:microsecond)
    result = IO.inspect("Hello #{name}!!")
    finish_time = System.monotonic_time(:microsecond)
    processing_time = finish_time - start_time
    [processing_time, result]
  end
end
