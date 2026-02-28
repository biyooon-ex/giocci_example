# GiocciExample

The example code and its instruction for [Giocci Platform](https://github.com/biyooon-ex/giocci_platform).

This explanation assumes that the GiocciRelay and GiocciEngine environment with your Zenoh router described in [Giocci's Quick Start](https://github.com/biyooon-ex/giocci_platform#quick-start) has already been deployed.
Also, please specify the Endpoint of your Zenoh router as `connect.endpoints` in zenoh_config.json5.

1. Deploy Zenoh router: `zenohd`
2. Deploy Giocci Relay: `docker compose up giocci_relay`
3. Deploy Giocci Engine: `docker compose up giocci_engine`

## compilation

```bash
git clone https://github.com/biyooon-ex/giocci_example
cd giocci_example
mix deps.get
mix compile
```

## Instruction

All subsequent operations will be performed on the IEx of GiocciClient (the project in this repository).
`#` and `##` mean output and description, respectively.

### Hello, World!!

Code: lib/giocci_example.ex

```elixir
## Execution on local
GiocciExample.hello
# => :world
## Execution on server
Giocci.register_client("giocci_relay")
# => :ok
Giocci.save_module("giocci_relay", GiocciExample)
# => :ok
Giocci.exec_func("giocci_relay", {GiocciExample, :hello, []})
# => :world
Giocci.exec_func("giocci_relay", {GiocciExample, :hello, ["Kazuma"]})
# => "Hello, Kazuma!!"
```

### Basic Calculation

Code: lib/giocci_example/basic_calc.ex

```elixir
## Execution on local
GiocciExample.BasicCalc.add(3, 4)
# 7
GiocciExample.BasicCalc.multiply(3, 4)
# 12
GiocciExample.BasicCalc.power(3, 4)
# 81.0
GiocciExample.BasicCalc.fib(34)
# 5702887

## Execution on server
## The below can be skipped when already registered
Giocci.register_client("giocci_relay")
# :ok
Giocci.save_module("giocci_relay", GiocciExample.BasicCalc)
# :ok
Giocci.exec_func("giocci_relay", {GiocciExample.BasicCalc, :add, [3, 4]})
# 7
Giocci.exec_func("giocci_relay", {GiocciExample.BasicCalc, :multiply, [3, 4]})
# 12
Giocci.exec_func("giocci_relay", {GiocciExample.BasicCalc, :power, [3, 4]})
# 81.0
Giocci.exec_func("giocci_relay", {GiocciExample.BasicCalc, :fib, [34]})
GiocciExample.BasicCalc.power(3, 4)
# 5702887
```

### Heavy Load

TIPS: If you're using on a powerful clients such as a laptop, it might be better to run IEx with `iex --erl "+S 1" -S mix` and prepare a powerful Engine :D

Code: lib/giocci_example/heavy_load.ex

```elixir
## Execution on local
GiocciExample.HeavyLoad.parallel_fib(34, 16)
# [5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887,
#  5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887]

## Execution on server
## The below can be skipped when already registered
Giocci.register_client("giocci_relay")
# :ok
Giocci.save_module("giocci_relay", GiocciExample.HeavyLoad)
# :ok
Giocci.exec_func("giocci_relay", {GiocciExample.HeavyLoad, :parallel_fib, [34, 16]})
# [5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887,
#  5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887]
```

### Measurement

Let's measure the execution time when running locally and on the Giocci server. The output is `{result, exec_time}` (in us).

Code: lib/giocci_example/measurer.ex

```elixir
## Execution on local
GiocciExample.Measurer.exec_func({GiocciExample.HeavyLoad, :parallel_fib, [34, 16]})
# {[5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887,
#   5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887],
#  1358682}

## Execution on server
## The below can be skipped when already registered
Giocci.register_client("giocci_relay")
# :ok
Giocci.save_module("giocci_relay", GiocciExample.HeavyLoad)
# :ok
GiocciExample.Measurer.exec_func("giocci_relay", {GiocciExample.HeavyLoad, :parallel_fib, [34, 16]})
# {[5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887,
#   5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887, 5702887],
#  217824}
```

### Asynchronous Execution

Here is an example of asynchronous execution using `Giocci.exec_func_async/3`.

Code: lib/giocci_example/async_server.ex

```elixir
## Start GenServer
GiocciExample.AsyncServer.start_link([])
# {:ok, #PID<0.205.0>}
## The below can be skipped when already registered
Giocci.register_client("giocci_relay")
# :ok
Giocci.save_module("giocci_relay", GiocciExample)
# :ok
Giocci.save_module("giocci_relay", GiocciExample.HeavyLoad)
# :ok
GiocciExample.AsyncServer.exec_func_async("giocci_relay", {GiocciExample.HeavyLoad, :parallel_fib, [40, 16]})
# :ok
GiocciExample.AsyncServer.exec_func_async("giocci_relay", {GiocciExample, :hello, ["Kazuma"]})
# :ok
# Received result: "Hello, Kazuma!!"
# Received result: [102334155, 102334155, 102334155, 102334155, 102334155, 102334155, 102334155, 102334155, 102334155, 102334155, 102334155, 102334155, 102334155, 102334155, 102334155, 102334155]
## Note that the order of received results was reversed!
```
