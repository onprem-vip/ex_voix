defmodule ExVoix.Utils.LvJs do

  # TODO: evaluate this, inspect from security point of view
  def eval(text) do
    {value, _} =
      text
      |> Code.string_to_quoted!()
      |> locals_calls_only
      |> in_module(__MODULE__)
      |> Code.eval_quoted

    value
  end

  defp in_module(ast, mod) do
    quote do
      alias unquote(Phoenix.LiveView.JS)
      # import unquote(Phoenix.VerifiedRoutes)
      import unquote(mod)
      # prevent Kernel.exit and others to be in scope
      # only allow function from the given module
      # TODO: put more restricted functions for doing the eval
      import Kernel, except: [
        exit: 1, dbg: 0, dbg: 1, dbg: 2, spawn: 1, spawn: 3, spawn_link: 1, spawn_link: 3, spawn_monitor: 1, spawn_monitor: 3,
        defimpl: 2, defimpl: 3, defmacro: 1, defmacro: 2, defmacrop: 1, defmacrop: 2, defoverridable: 1, defprotocol: 2,
        alias!: 1,
      ]
      unquote(ast)
    end
  end

  defp locals_calls_only(ast) do
    ast
    |> Macro.prewalk(fn
      # dont allow remote function calls
      code = {{:., _, c}, _, _} ->
        # IO.inspect(c)
        case c do
          [{:__aliases__, _, [:JS]}, _] -> code

          _ ->
            IO.puts("warning: removed non local call #{inspect(code)}")
            nil
        end
        # IO.puts("warning: removed non local call #{inspect(evil)}")
        # nil

      # dont allow calling to eval and prevent loops
      {:eval, _, args} when is_list(args) ->
        IO.puts("warning: removed call to eval")
        nil

      # either raise or rewrite the code
      code -> code
    end)
  end
end
