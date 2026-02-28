defmodule GiocciExample.Measurer do
  def exec_func({module, func, args}) do
    start_time = System.monotonic_time(:microsecond)
    result = :erlang.apply(module, func, args)
    finish_time = System.monotonic_time(:microsecond)
    exec_time = finish_time - start_time
    {result, exec_time}
  end

  def exec_func(relay, {module, func, args}) do
    start_time = System.monotonic_time(:microsecond)
    result = Giocci.exec_func(relay, {module, func, args})
    finish_time = System.monotonic_time(:microsecond)
    exec_time = finish_time - start_time
    {result, exec_time}
  end
end
