defmodule GiocciExample.AsyncServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    # Execute async function
    {:ok, %{}}
  end

  def exec_func_async(relay, {module, func, args}) do
    GenServer.cast(__MODULE__, {:exec_func_async, relay, {module, func, args}})
  end

  def handle_cast({:exec_func_async, relay, {module, func, args}}, state) do
    Giocci.exec_func_async(relay, {module, func, args}, self())
    {:noreply, state}
  end

  def handle_info({:giocci, result}, state) do
    IO.puts("Received result: #{inspect(result)}")
    {:noreply, state}
  end
end
