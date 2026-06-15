defmodule GiocciExample.IntegrationTest do
  use ExUnit.Case, async: false

  @moduledoc """
  Tests that verify local execution results match remote Giocci execution
  for random inputs. These tests require a running Zenoh router, GiocciRelay,
  and GiocciEngine (see README for prerequisites).
  """

  @relay "giocci_relay"

  setup_all do
    :ok = Giocci.register_client(@relay)
    :ok = Giocci.save_module(@relay, GiocciExample)
    :ok = Giocci.save_module(@relay, GiocciExample.BasicCalc)
    :ok = Giocci.save_module(@relay, GiocciExample.HeavyLoad)
    :ok
  end

  describe "GiocciExample" do
    test "hello/0: remote result matches local" do
      assert Giocci.exec_func(@relay, {GiocciExample, :hello, []}) == GiocciExample.hello()
    end

    test "hello/1: remote result matches local for random name" do
      name = "User#{:rand.uniform(9999)}"

      assert Giocci.exec_func(@relay, {GiocciExample, :hello, [name]}) ==
               GiocciExample.hello(name)
    end
  end

  describe "GiocciExample.BasicCalc" do
    test "add/2: remote result matches local for random inputs" do
      {a, b} = {:rand.uniform(1000), :rand.uniform(1000)}

      assert Giocci.exec_func(@relay, {GiocciExample.BasicCalc, :add, [a, b]}) ==
               GiocciExample.BasicCalc.add(a, b)
    end

    test "multiply/2: remote result matches local for random inputs" do
      {a, b} = {:rand.uniform(100), :rand.uniform(100)}

      assert Giocci.exec_func(@relay, {GiocciExample.BasicCalc, :multiply, [a, b]}) ==
               GiocciExample.BasicCalc.multiply(a, b)
    end

    test "power/2: remote result matches local for random inputs" do
      {a, b} = {:rand.uniform(10), :rand.uniform(5)}

      assert Giocci.exec_func(@relay, {GiocciExample.BasicCalc, :power, [a, b]}) ==
               GiocciExample.BasicCalc.power(a, b)
    end

    test "fib/1: remote result matches local for random input" do
      n = :rand.uniform(20)

      assert Giocci.exec_func(@relay, {GiocciExample.BasicCalc, :fib, [n]}) ==
               GiocciExample.BasicCalc.fib(n)
    end
  end

  describe "GiocciExample.HeavyLoad" do
    test "parallel_fib/2: remote result matches local for random inputs" do
      # Keep small to avoid long test times; num: 6..15, count: 2..5
      num = :rand.uniform(10) + 5
      count = :rand.uniform(4) + 1

      assert Giocci.exec_func(@relay, {GiocciExample.HeavyLoad, :parallel_fib, [num, count]}) ==
               GiocciExample.HeavyLoad.parallel_fib(num, count)
    end
  end

  describe "GiocciExample.Measurer" do
    # For Measurer tests, we verify that the result tuple {result, exec_time} is correct:
    # - result matches the expected computation value
    # - exec_time is a non-negative integer (exact timing is not compared)

    test "exec_func/1 (local): result tuple has correct structure and value" do
      {a, b} = {:rand.uniform(100), :rand.uniform(100)}
      expected = GiocciExample.BasicCalc.add(a, b)

      assert {^expected, exec_time} =
               GiocciExample.Measurer.exec_func({GiocciExample.BasicCalc, :add, [a, b]})

      assert is_integer(exec_time) and exec_time >= 0
    end

    test "exec_func/2 (remote): result tuple has correct structure and value" do
      {a, b} = {:rand.uniform(100), :rand.uniform(100)}
      expected = GiocciExample.BasicCalc.add(a, b)

      assert {^expected, exec_time} =
               GiocciExample.Measurer.exec_func(@relay, {GiocciExample.BasicCalc, :add, [a, b]})

      assert is_integer(exec_time) and exec_time >= 0
    end

    test "exec_func/1 and exec_func/2: result values match for random inputs" do
      # num: 5..12, count: 2..4
      num = :rand.uniform(8) + 4
      count = :rand.uniform(3) + 1

      {local_result, _} =
        GiocciExample.Measurer.exec_func({GiocciExample.HeavyLoad, :parallel_fib, [num, count]})

      {remote_result, _} =
        GiocciExample.Measurer.exec_func(
          @relay,
          {GiocciExample.HeavyLoad, :parallel_fib, [num, count]}
        )

      assert local_result == remote_result
    end
  end

  describe "async execution" do
    # Tests call Giocci.exec_func_async/3 with self() so that the result message
    # {:giocci, result} is delivered to the test process and can be asserted.

    test "exec_func_async BasicCalc.add: result matches local for random inputs" do
      {a, b} = {:rand.uniform(1000), :rand.uniform(1000)}
      local_result = GiocciExample.BasicCalc.add(a, b)

      :ok = Giocci.exec_func_async(@relay, {GiocciExample.BasicCalc, :add, [a, b]}, self())

      assert_receive {:giocci, ^local_result}, 10_000
    end

    test "exec_func_async HeavyLoad.parallel_fib: result matches local for random inputs" do
      # num: 5..12, count: 2..4 — kept small for reasonable test duration
      num = :rand.uniform(8) + 4
      count = :rand.uniform(3) + 1
      local_result = GiocciExample.HeavyLoad.parallel_fib(num, count)

      :ok =
        Giocci.exec_func_async(
          @relay,
          {GiocciExample.HeavyLoad, :parallel_fib, [num, count]},
          self()
        )

      assert_receive {:giocci, ^local_result}, 30_000
    end

    test "exec_func_async GiocciExample.hello/1: result matches local for random name" do
      name = "User#{:rand.uniform(9999)}"
      local_result = GiocciExample.hello(name)

      :ok = Giocci.exec_func_async(@relay, {GiocciExample, :hello, [name]}, self())

      assert_receive {:giocci, ^local_result}, 10_000
    end
  end
end
