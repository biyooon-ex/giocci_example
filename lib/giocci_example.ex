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

  def hello(name) do
    IO.inspect("Hello, #{name}!!")
  end
end
