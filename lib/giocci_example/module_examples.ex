defmodule GiocciExample.ModuleExamples do
  def inspect_saved_module(relay, module) do
    module_name = Atom.to_string(module)

    with {:ok, modules} <- Giocci.Inspect.list_modules(relay),
         {:ok, functions} <- Giocci.Inspect.list_functions(relay, module_name) do
      {:ok, %{modules: modules, functions: functions}}
    end
  end

  def compile_dynamic_calc do
    [{module, _beam}] =
      Code.compile_string("""
      defmodule GiocciExample.DynamicCalc do
        use Giocci.DynamicModule

        def add(a, b), do: a + b
      end
      """)

    module
  end
end
