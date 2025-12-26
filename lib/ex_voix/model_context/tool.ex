defmodule ExVoix.ModelContext.Tool do

  alias ExVoix.ModelContext.Registry

  def call(event) do
    target_name = Map.get(event, "tool_name")
    detail = Map.get(event, "detail")

    mcps = Registry.load_mcps()
    mcp =
      Enum.filter(mcps, fn mcp -> length(Registry.load_tool(mcp, target_name, false)) > 0 end)
      |> Enum.flat_map(&(&1)) |> Enum.at(0)
    if not is_nil(mcp) do
      [tool_info] = Registry.load_tool(mcp, target_name, false)
      mcp.call_tool(Map.get(tool_info, "name"), detail)
    end
  end
end
